require "descriptions"
require "cmd/search"

module Homebrew
  def desc
    if ARGV.options_only.empty?
      if ARGV.named.empty?
        raise FormulaUnspecifiedError
        exit
      end
      results = Descriptions.named(ARGV.formulae.map(&:full_name))
    else
      searches = {
        '-s' => :either,
        '-n' => :name,
        '-d' => :desc
      }
      provided = ARGV.options_only & searches.keys

      if (ARGV.options_only - searches.keys).any?
        odie "Unrecognized options."
      elsif provided.size > 1
        odie "Pick one, and only one, of -s, -n, or -d."
      end

      flag = provided.first

      if arg = ARGV.named.first
        regex = Homebrew::query_regexp(arg)
        results = Descriptions.search(regex, searches[flag])
      else
        odie "You must provide a search term."
      end
    end

    results.print unless results.nil?
  end
end
