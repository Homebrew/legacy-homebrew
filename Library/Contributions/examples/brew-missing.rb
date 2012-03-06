require "formula"
require "cmd/outdated"

def installed_brews
  formulae = []
  HOMEBREW_CELLAR.subdirs.each do |rack|
    f = Formula.factory rack.basename.to_s rescue nil
    formulae << f if f and f.installed?
  end
  formulae
end

def main
  return unless HOMEBREW_CELLAR.exist?

  # Names of outdated brews; they count as installed.
  outdated = Homebrew.outdated_brews.collect{ |b| b.name }

  formulae_to_check = if ARGV.named.empty?
    installed_brews
  else
    ARGV.formulae
  end

  formulae_to_check.each do |f|
    missing_deps = f.recursive_deps.map{ |g| g.name }.uniq.reject do |dep_name|
      Formula.factory(dep_name).installed? or outdated.include?(dep_name)
    end

    unless missing_deps.empty?
      print "#{f.name}: " if formulae_to_check.size > 1
      puts "#{missing_deps * ' '}"
    end
  end
end

main()
