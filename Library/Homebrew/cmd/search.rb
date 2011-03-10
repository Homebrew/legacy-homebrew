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
      search_results = search_brews query
      puts_columns search_results

      if not query.to_s.empty? and $stdout.tty? and msg = blacklisted?(query)
        unless search_results.empty?
          puts
          puts "If you meant `#{query}' precisely:"
          puts
        end
        puts msg
      end
    end
  end

  def search_brews text
    if text.to_s.empty?
      Formula.names
    else
      rx = if text =~ %r{^/(.*)/$}
        Regexp.new($1)
      else
        /.*#{Regexp.escape text}.*/i
      end

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
