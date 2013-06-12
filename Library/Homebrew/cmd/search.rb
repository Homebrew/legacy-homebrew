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
      search_results = search_brews rx
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
        $found = search_results.length

        threads = []
        results = []
        threads << Thread.new { search_tap "josegonzalez", "php", rx }
        threads << Thread.new { search_tap "samueljohn", "python", rx }
        threads << Thread.new { search_tap "Homebrew", "apache", rx }
        threads << Thread.new { search_tap "Homebrew", "versions", rx }
        threads << Thread.new { search_tap "Homebrew", "dupes", rx }
        threads << Thread.new { search_tap "Homebrew", "games", rx }
        threads << Thread.new { search_tap "Homebrew", "science", rx }
        threads << Thread.new { search_tap "Homebrew", "completions", rx }
        threads << Thread.new { search_tap "Homebrew", "x11", rx }

        threads.each do |t|
          results << t.value
        end

        results.each { |r| puts_columns r }

        if $found == 0 and not blacklisted? query
          puts "No formula found for #{query.inspect}. Searching open pull requests..."
          GitHub.find_pull_requests(rx) { |pull| puts pull }
        end
      end
    end
  end

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
          $found += 1
        end
      end
    end
    results
  end

  def search_brews rx
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
