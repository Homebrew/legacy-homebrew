require 'formula'

# `brew uses foo bar` now returns formula that use both foo and bar
# Rationale: If you want the union just run the command twice and
# concatenate the results.
# The intersection is harder to achieve with shell tools.

module Homebrew extend self
  def uses
    raise FormulaUnspecifiedError if ARGV.named.empty?

    uses = Formula.all.select do |f|
      ARGV.formulae.all? do |ff|
        if ARGV.flag? '--recursive'
          f.recursive_deps.include? ff
        else
          f.deps.include? ff.name
        end
      end
    end

    if ARGV.include? "--installed"
      uses = uses.select do |f|
        keg = HOMEBREW_CELLAR/f
        keg.directory? and not keg.subdirs.empty?
      end
    end

    puts_columns uses.map{|f| f.to_s}.sort
  end
end
