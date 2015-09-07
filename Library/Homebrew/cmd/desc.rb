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
      if ARGV.options_only.count != 1
        odie "Pick one, and only one, of -s/--search, -n/--name, or -d/--description."
      end

      search_arg = ARGV.options_only.first

      search_type = case search_arg
        when '-s', '--search'
          :either
        when '-n', '--name'
          :name
        when '-d', '--description'
          :desc
        else
          odie "Unrecognized option '#{search_arg}'."
        end

      if arg = ARGV.named.first
        regex = Homebrew::query_regexp(arg)
        results = Descriptions.search(regex, search_type)
      else
        odie "You must provide a search term."
      end
    end

    results.print unless results.nil?
  end
end
