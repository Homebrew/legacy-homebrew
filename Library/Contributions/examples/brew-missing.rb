require "formula"
require "cmd/outdated"

def main
  # Names of outdated brews; they count as installed.
  outdated = Homebrew.outdated_brews.collect{ |b| b[1] }

  HOMEBREW_CELLAR.subdirs.each do |rack|
    f = Formula.factory rack.basename.to_s rescue nil
    if f and f.installed?
      missing_deps = f.recursive_deps.map{ |g| g.name }.uniq.reject do |dep_name|
        Formula.factory(dep_name).installed? or outdated.include?(dep_name)
      end

      puts "#{f.name}: #{missing_deps * ', '}" unless missing_deps.empty?
    end
  end
end

main()
