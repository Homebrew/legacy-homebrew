require 'formula'
require 'blacklist'
require 'utils'
require 'thread'

module Homebrew

  SEARCH_ERROR_QUEUE = Queue.new

  def search
    if ARGV.include? '--macports'
      exec_browser "http://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? '--fink'
      exec_browser "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.include? '--debian'
      exec_browser "http://packages.debian.org/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.include? '--opensuse'
      exec_browser "http://software.opensuse.org/search?q=#{ARGV.next}"
    elsif ARGV.include? '--fedora'
      exec_browser "https://admin.fedoraproject.org/pkgdb/acls/list/*#{ARGV.next}*"
    elsif ARGV.include? '--ubuntu'
      exec_browser "http://packages.ubuntu.com/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.empty?
      puts_columns Formula.names
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

      if not query.empty? and $stdout.tty? and msg = blacklisted?(query)
        unless local_results.empty?
          puts
          puts "If you meant #{query.inspect} precisely:"
          puts
        end
        puts msg
      end

      tap_results = search_taps(rx)
      puts_columns(tap_results)
      count = local_results.length + tap_results.length

      if count == 0 and not blacklisted? query
        puts "No formula found for #{query.inspect}."
        begin
          GitHub.print_pull_requests_matching(query)
        rescue GitHub::Error => e
          SEARCH_ERROR_QUEUE << e
        end
      end
    end

    raise SEARCH_ERROR_QUEUE.pop unless SEARCH_ERROR_QUEUE.empty?
  end

  SEARCHABLE_TAPS = [
    %w{Homebrew nginx},
    %w{Homebrew apache},
    %w{Homebrew versions},
    %w{Homebrew dupes},
    %w{Homebrew games},
    %w{Homebrew science},
    %w{Homebrew completions},
    %w{Homebrew binary},
    %w{Homebrew python},
    %w{Homebrew php},
  ]

  def query_regexp(query)
    case query
    when %r{^/(.*)/$} then Regexp.new($1)
    else /.*#{Regexp.escape(query)}.*/i
    end
  end

  def search_taps(rx)
    SEARCHABLE_TAPS.map do |user, repo|
      Thread.new { search_tap(user, repo, rx) }
    end.inject([]) do |results, t|
      results.concat(t.value)
    end
  end

  def search_tap user, repo, rx
    return [] if (HOMEBREW_LIBRARY/"Taps/#{user.downcase}/homebrew-#{repo.downcase}").directory?

    results = []
    tree = {}

    GitHub.open "https://api.github.com/repos/#{user}/homebrew-#{repo}/git/trees/HEAD?recursive=1" do |json|
      user = user.downcase if user == "Homebrew" # special handling for the Homebrew organization
      json["tree"].each do |object|
        next unless object["type"] == "blob"

        subtree, file = File.split(object["path"])

        if File.extname(file) == ".rb"
          tree[subtree] ||= []
          tree[subtree] << file
        end
      end
    end

    paths = tree["Formula"] || tree["HomebrewFormula"] || tree["."] || []
    paths.each do |path|
      name = File.basename(path, ".rb")
      results << "#{user}/#{repo}/#{name}" if rx === name
    end
  rescue GitHub::HTTPNotFoundError => e
    opoo "Failed to search tap: #{user}/#{repo}. Please run `brew update`"
    []
  rescue GitHub::Error => e
    SEARCH_ERROR_QUEUE << e
    []
  else
    results
  end

  def search_formulae rx
    aliases = Formula.aliases
    results = (Formula.names+aliases).grep(rx).sort

    # Filter out aliases when the full name was also found
    results.reject do |name|
      canonical_name = Formulary.canonical_name(name)
      aliases.include?(name) && results.include?(canonical_name)
    end
  end
end
