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
  # Names of outdated brews; they count as installed.
  outdated = Homebrew.outdated_brews.collect{ |b| b[1] }

  formuale_to_check = ARGV.formulae rescue installed_brews

  formuale_to_check.each do |f|
    missing_deps = f.recursive_deps.map{ |g| g.name }.uniq.reject do |dep_name|
      Formula.factory(dep_name).installed? or outdated.include?(dep_name)
    end

    unless missing_deps.empty?
      print "#{f.name}: " if formuale_to_check.size > 1
      puts "#{missing_deps * ', '}"
    end
  end
end

main()
