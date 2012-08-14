require 'formula'
require 'cmd/outdated'

module Homebrew extend self
  def installed_brews
    formulae = []
    HOMEBREW_CELLAR.subdirs.each do |rack|
      f = Formula.factory rack.basename.to_s rescue nil
      formulae << f if f and f.installed?
    end
    formulae
  end

  def find_missing_brews top_level
    # Names of outdated brews; they count as installed.
    outdated = Homebrew.outdated_brews.collect{ |b| b.name }

    brews = []
    top_level.each do |f|
      missing_deps = f.recursive_deps.map{ |g| g.name }.uniq.reject do |dep_name|
        Formula.factory(dep_name).installed? or outdated.include?(dep_name)
      end

      unless missing_deps.empty?
        brews << [f.name, missing_deps]
      end
    end
    brews
  end

  def missing
    return unless HOMEBREW_CELLAR.exist?

    formulae_to_check = if ARGV.named.empty?
      installed_brews
    else
      ARGV.formulae
    end

    missing_deps = find_missing_brews(formulae_to_check)
    missing_deps.each do |d|
      name = d[0]
      missing = d[1]
      print "#{name}: " if formulae_to_check.size > 1
      puts "#{missing * ' '}"
    end
  end
end
