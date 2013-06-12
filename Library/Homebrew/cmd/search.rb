require 'formula'
require 'blacklist'
require 'utils'
require 'vendor/multi_json'

module Homebrew extend self
  def search
    if ARGV.include? '--macports'
      exec_browser "http://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? '--fink'
      exec_browser "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.include? '--debian'
      exec_browser "http://packages.debian.org/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    else
      query = ARGV.first
      rx = query_regexp(query)
      search_results = search_formulae rx
      puts_columns search_results

      if not query.to_s.empty? and $stdout.tty? and msg = blacklisted?(query)
        unless search_results.empty?
          puts
          puts "If you meant #{query.inspect} precisely:"
          puts
        end
        puts msg
      end

      if query
        found = search_results.length

        results = []

        SEARCHABLE_TAPS.map do |user, repo|
          Thread.new { search_tap(user, repo, rx) }
        end.each do |t|
          results.concat(t.value)
        end

        puts_columns(results)
        found += results.length

        if found == 0 and not blacklisted? query
          puts "No formula found for #{query.inspect}. Searching open pull requests..."
          GitHub.find_pull_requests(rx) { |pull| puts pull }
        end
      end
    end
  end

  SEARCHABLE_TAPS = [
    %w{josegonzalez php},
    %w{samueljohn python},
    %w{Homebrew apache},
    %w{Homebrew versions},
    %w{Homebrew dupes},
    %w{Homebrew games},
    %w{Homebrew science},
    %w{Homebrew completions},
    %w{Homebrew x11},
  ]

  def query_regexp(query)
    case query
    when nil then ""
    when %r{^/(.*)/$} then Regexp.new($1)
    else /.*#{Regexp.escape(query)}.*/i
    end
  end

  def search_tap user, repo, rx
    return [] if (HOMEBREW_LIBRARY/"Taps/#{user.downcase}-#{repo.downcase}").directory?

    results = []
    GitHub.open "https://api.github.com/repos/#{user}/homebrew-#{repo}/git/trees/HEAD?recursive=1" do |f|
      user.downcase! if user == "Homebrew" # special handling for the Homebrew organization
      MultiJson.decode(f.read)["tree"].map{ |hash| hash['path'] }.compact.each do |file|
        name = File.basename(file, '.rb')
        if file =~ /\.rb$/ and name =~ rx
          results << "#{user}/#{repo}/#{name}"
        end
      end
    end
    results
  end

  def search_formulae rx
    if rx.to_s.empty?
      Formula.names
    else
      aliases = Formula.aliases
      results = (Formula.names+aliases).grep rx

      # Filter out aliases when the full name was also found
      results.reject do |alias_name|
        if aliases.include? alias_name
          resolved_name = (HOMEBREW_REPOSITORY+"Library/Aliases"+alias_name).readlink.basename('.rb').to_s
          results.include? resolved_name
        end
      end
    end
  end
end
