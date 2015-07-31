require 'descriptions'
require 'cmd/search'

USAGE =<<EOM
Print formula descriptions.

Usage:

    brew desc --decache             Delete the cache, if present
    brew desc --recache             [Re]generate the cache
    brew desc name [name ...]       Describe the named formula(e)
    brew desc (-s|-n|-d) <string>   Search specifed fields for string
    brew desc (-s|-n|-d) /<regex>/  Search specifed fields for regex
EOM


module Homebrew
  def desc
    options = ARGV.options_only

    if options.include?("--decache")
      Descriptions.delete_cache
      options.delete("--decache")
      cache_op = true
    end

    if options.include?("--recache")
      Descriptions.generate_cache
      options.delete("--recache")
      cache_op = true
    end

    if options.empty?
      if ARGV.named.empty?
        print USAGE unless cache_op
        exit
      else
        results = Descriptions.named(ARGV.named)
      end
    else
      searches = {
        '-s' => :either,
        '-n' => :name,
        '-d' => :desc
      }
      provided = options & searches.keys
      odie "Pick one, and only one, of -s, -n, or -d." unless provided.size.eql?(1)
      flag = provided.first

      if arg = ARGV.named.first
        regex = Homebrew::query_regexp(arg)
        results = Descriptions.matching(regex, searches[flag])
      else
        odie "You must provide a search term."
      end
    end
    Descriptions.print(results)
  end
end
