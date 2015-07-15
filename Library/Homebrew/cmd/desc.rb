require 'descriptions'
require 'cmd/search'

module Homebrew
  def desc
    options = ARGV.options_only

    if options.include?("--decache")
      Descriptions.delete_cache
      options.delete("--decache")
    end

    if options.include?("--cache")
      Descriptions.generate_cache
      options.delete("--cache")
    end

    if options.empty?
      results = Descriptions.named(ARGV.named)
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
