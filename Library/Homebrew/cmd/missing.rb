require 'formula'

module Homebrew extend self
  def installed_brews
    formulae = []
    HOMEBREW_CELLAR.subdirs.each do |rack|
      f = Formula.factory rack.basename.to_s rescue nil
      formulae << f if f and f.rack.exist? and f.rack.subdirs.length > 0
    end
    formulae
  end

  def missing_deps ff
    missing = {}
    ff.each do |f|
      missing_deps = f.recursive_deps.uniq.reject do |dep|
          dep.rack.exist? and dep.rack.subdirs.length > 0
        end

      unless missing_deps.empty?
        yield f.name, missing_deps if block_given?
        missing[f.name] = missing_deps
      end
    end
    missing
  end

  def missing
    return unless HOMEBREW_CELLAR.exist?

    ff = if ARGV.named.empty?
      installed_brews
    else
      ARGV.formulae
    end

    missing_deps(ff) do |name, missing|
      print "#{name}: " if ff.size > 1
      puts "#{missing * ' '}"
    end
  end
end
