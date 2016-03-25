require "formula"
require "blacklist"
require "utils"
require "thread"
require "official_taps"
require "descriptions"

module Homebrew
  SEARCH_ERROR_QUEUE = Queue.new

  def search
    if ARGV.empty?
      puts_columns Formula.full_names
    elsif ARGV.include? "--macports"
      exec_browser "https://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? "--fink"
      exec_browser "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.include? "--debian"
      exec_browser "https://packages.debian.org/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.include? "--opensuse"
      exec_browser "https://software.opensuse.org/search?q=#{ARGV.next}"
    elsif ARGV.include? "--fedora"
      exec_browser "https://admin.fedoraproject.org/pkgdb/packages/%2A#{ARGV.next}%2A/"
    elsif ARGV.include? "--ubuntu"
      exec_browser "http://packages.ubuntu.com/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.include? "--desc"
      query = ARGV.next
      rx = query_regexp(query)
      Descriptions.search(rx, :desc).print
    elsif ARGV.first =~ HOMEBREW_TAP_FORMULA_REGEX
      query = ARGV.first
      user, repo, name = query.split("/", 3)

      begin
        result = Formulary.factory(query).name
      rescue FormulaUnavailableError
        result = search_tap(user, repo, name)
      end

      puts_columns Array(result)
    else
      query = ARGV.first
      rx = query_regexp(query)
      local_results = search_formulae(rx)
      puts_columns(local_results)
      tap_results = search_taps(rx)
      puts_columns(tap_results)

      if $stdout.tty?
        count = local_results.length + tap_results.length

        if msg = blacklisted?(query)
          if count > 0
            puts
            puts "If you meant #{query.inspect} precisely:"
            puts
          end
          puts msg
        elsif count == 0
          puts "No formula found for #{query.inspect}."
          begin
            GitHub.print_pull_requests_matching(query)
          rescue GitHub::Error => e
            SEARCH_ERROR_QUEUE << e
          end
        end
      end
    end

    if $stdout.tty?
      metacharacters = %w[\\ | ( ) [ ] { } ^ $ * + ? .]
      bad_regex = metacharacters.any? do |char|
        ARGV.any? do |arg|
          arg.include?(char) && !arg.start_with?("/")
        end
      end
      if ARGV.any? && bad_regex
        ohai "Did you mean to perform a regular expression search?"
        ohai "Surround your query with /slashes/ to search by regex."
      end
    end

    raise SEARCH_ERROR_QUEUE.pop unless SEARCH_ERROR_QUEUE.empty?
  end

  SEARCHABLE_TAPS = OFFICIAL_TAPS.map { |tap| ["Homebrew", tap] } + [
    %w[Caskroom cask],
    %w[Caskroom versions]
  ]

  def query_regexp(query)
    case query
    when %r{^/(.*)/$} then Regexp.new($1)
    else /.*#{Regexp.escape(query)}.*/i
    end
  rescue RegexpError
    odie "#{query} is not a valid regex"
  end

  def search_taps(rx)
    SEARCHABLE_TAPS.map do |user, repo|
      Thread.new { search_tap(user, repo, rx) }
    end.inject([]) do |results, t|
      results.concat(t.value)
    end
  end

  def search_tap(user, repo, rx)
    if (HOMEBREW_LIBRARY/"Taps/#{user.downcase}/homebrew-#{repo.downcase}").directory? && \
       user != "Caskroom"
      return []
    end

    @@remote_tap_formulae ||= Hash.new do |cache, key|
      user, repo = key.split("/", 2)
      tree = {}

      GitHub.open "https://api.github.com/repos/#{user}/homebrew-#{repo}/git/trees/HEAD?recursive=1" do |json|
        json["tree"].each do |object|
          next unless object["type"] == "blob"

          subtree, file = File.split(object["path"])

          if File.extname(file) == ".rb"
            tree[subtree] ||= []
            tree[subtree] << file
          end
        end
      end

      paths = tree["Formula"] || tree["HomebrewFormula"] || tree["Casks"] || tree["."] || []
      cache[key] = paths.map { |path| File.basename(path, ".rb") }
    end

    names = @@remote_tap_formulae["#{user}/#{repo}"]
    user = user.downcase if user == "Homebrew" # special handling for the Homebrew organization
    names.select { |name| rx === name }.map { |name| "#{user}/#{repo}/#{name}" }
  rescue GitHub::HTTPNotFoundError => e
    opoo "Failed to search tap: #{user}/#{repo}. Please run `brew update`"
    []
  rescue GitHub::Error => e
    SEARCH_ERROR_QUEUE << e
    []
  end

  def search_formulae(rx)
    aliases = Formula.alias_full_names
    results = (Formula.full_names+aliases).grep(rx).sort

    results.map do |name|
      begin
        formula = Formulary.factory(name)
        canonical_name = formula.name
        canonical_full_name = formula.full_name
      rescue
        canonical_name = canonical_full_name = name
      end
      # Ignore aliases from results when the full name was also found
      if aliases.include?(name) && results.include?(canonical_full_name)
        next
      elsif (HOMEBREW_CELLAR/canonical_name).directory?
        pretty_installed(name)
      else
        name
      end
    end.compact
  end
end
