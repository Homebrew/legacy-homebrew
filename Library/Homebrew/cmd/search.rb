require "formula"
require "blacklist"

module Homebrew extend self
  def search
    if ARGV.include? '--macports'
      exec "open", "http://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? '--fink'
      exec "open", "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    else
      query = ARGV.first
      rx = if query =~ %r{^/(.*)/$}
        Regexp.new($1)
      else
        /.*#{Regexp.escape query}.*/i
      end

      search_results = search_brews rx
      puts_columns search_results

      if not query.to_s.empty? and $stdout.tty? and msg = blacklisted?(query)
        unless search_results.empty?
          puts
          puts "If you meant `#{query}' precisely:"
          puts
        end
        puts msg
      end

      if search_results.empty? and not blacklisted? query
        pulls = GitHub.find_pull_requests rx
        unless pulls.empty?
          puts "Open pull requests matching \"#{query}\":", *pulls.map { |p| "    #{p}" }
        end
      end
    end
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
