require 'formula'
require 'blacklist'
require 'utils'
require 'utils/json'

module Homebrew extend self

  # A regular expession to capture the username (one or more char but no `/`,
  # which has to be escaped like `\/`), repository, followed by an optional `/`
  # and an optional query.
  TAP_QUERY_REGEX = /^([^\/]+)\/([^\/]+)\/?(.+)?$/

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
    elsif (query = ARGV.first).nil?
      puts_columns Formula.names
    elsif ARGV.first =~ TAP_QUERY_REGEX
      # So look for user/repo/query or list all formulae by the tap
      # we downcase to avoid case-insensitive filesystem issues.
      user, repo, query = $1.downcase, $2.downcase, $3
      tap_dir = HOMEBREW_LIBRARY/"Taps/#{user}-#{repo}"
      # If, instead of `user/repo/query` the user wrote `user/repo query`:
      query = ARGV[1] if query.nil?
      if tap_dir.directory?
        # There is a local tap already:
        result = Dir["#{tap_dir}/*.rb"].map{ |f| File.basename(f).chomp('.rb') }
        result = result.grep(query_regexp(query)) unless query.nil?
      else
        # Search online:
        query = '' if query.nil?
        result = search_tap(user, repo, query_regexp(query))
      end
      puts_columns result
    else
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
        puts "No formula found for #{query.inspect}. Searching open pull requests..."
        begin
          GitHub.find_pull_requests(rx) { |pull| puts pull }
        rescue GitHub::Error => e
          opoo e.message
        end
      end
    end
  end

  SEARCHABLE_TAPS = [
    %w{josegonzalez php},
    %w{samueljohn python},
    %w{marcqualie nginx},
    %w{Homebrew apache},
    %w{Homebrew versions},
    %w{Homebrew dupes},
    %w{Homebrew games},
    %w{Homebrew science},
    %w{Homebrew completions},
    %w{Homebrew x11},
    %w{Homebrew binary},
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
    return [] if (HOMEBREW_LIBRARY/"Taps/#{user.downcase}-#{repo.downcase}").directory?

    results = []
    GitHub.open "https://api.github.com/repos/#{user}/homebrew-#{repo}/git/trees/HEAD?recursive=1" do |f|
      user.downcase! if user == "Homebrew" # special handling for the Homebrew organization
      Utils::JSON.load(f.read)["tree"].map{ |hash| hash['path'] }.compact.each do |file|
        name = File.basename(file, '.rb')
        if file =~ /\.rb$/ and name =~ rx
          results << "#{user}/#{repo}/#{name}"
        end
      end
    end
    results
  rescue GitHub::Error, Utils::JSON::Error
    []
  end

  def search_formulae rx
    aliases = Formula.aliases
    results = (Formula.names+aliases).grep(rx)

    # Filter out aliases when the full name was also found
    results.reject do |alias_name|
      if aliases.include? alias_name
        resolved_name = (HOMEBREW_REPOSITORY+"Library/Aliases"+alias_name).readlink.basename('.rb').to_s
        results.include? resolved_name
      end
    end
  end
end
