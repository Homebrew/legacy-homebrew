require 'formula'

# `brew uses foo bar` now returns formula that use both foo and bar
# Rationale: If you want the union just run the command twice and
# concatenate the results.
# The intersection is harder to achieve with shell tools.

module Homebrew extend self
  def uses
    uses = Formula.all.select do |f|
      ARGV.formulae.all? do |ff|
        # For each formula given, show which other formulas depend on it.
        # We only go one level up, ie. direct dependencies.
        f.deps.include? ff.name
      end
    end
    if ARGV.include? "--installed"
      uses = uses.select do |f|
        keg = HOMEBREW_CELLAR/f
        keg.directory? and not keg.subdirs.empty?
      end
    end
    puts_columns uses.map(&:to_s).sort
  end
end
