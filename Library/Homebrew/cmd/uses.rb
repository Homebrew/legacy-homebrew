module Homebrew extend self
  def uses
    uses = Formula.all.select do |f|
      ARGV.formulae.all? do |ff|
        # For each formula given, show which other formulas depend on it.
        # We only go one level up, ie. direct dependencies.
        f.deps.include? ff.name
      end
    end
    uses.select! do |f|
      keg = HOMEBREW_CELLAR/f
      keg.directory? and not keg.subdirs.empty?
    end if ARGV.include? "--installed"
    puts uses.sort
  end
end
