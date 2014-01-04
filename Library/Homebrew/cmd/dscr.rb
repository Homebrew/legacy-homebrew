require 'formula'
require 'blacklist'
require 'net/http'
require 'uri'

module Homebrew extend self
  def dscr
    if ARGV.named.empty?
      if ARGV.include? "--all"
        Formula.each do |f|
          dscr_formula f
        end
      end
    else
      ARGV.named.each do |f|
        begin
          dscr_formula Formula.factory(f)
        rescue FormulaUnavailableError
          # No formula with this name, try a blacklist lookup
          if (blacklist = blacklisted?(f))
            puts blacklist
          else
            raise
          end
        end
      end
    end
  end

  def dscr_formula f
    formula_home_res = Net::HTTP.get_response URI(f.homepage)
    if formula_home_res.is_a? Net::HTTPSuccess
      desc_meta_class = /(<meta name="description" content=")(.*)("[ ][\/]>)/
      desc = formula_home_res.body.match(desc_meta_class)
      if desc.kind_of? MatchData
        desc = desc.captures[1]
      end
      if desc.kind_of? String
        ohai "Description: #{f.name}", desc
      else
        onoe "No description for #{f.name}"
      end
    else
      onoe "Could not connect to #{f.homepage}"
    end
  end
end
