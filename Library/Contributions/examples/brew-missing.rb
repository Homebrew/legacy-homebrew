require "formula"
require 'formula_installer'

def main
  # Names of outdated brews; they count as installed.
  outdated = outdated_brews.collect {|b| b[1]}

  HOMEBREW_CELLAR.subdirs.each do |keg|
    next unless keg.subdirs
    if ((f = Formula.factory(keg.basename.to_s)).installed? rescue false)
      f_deps = FormulaInstaller.expand_deps(f).collect{|g| g.name}.uniq
      next if f_deps.empty?

      missing_deps = f_deps.reject do |dep_name|
        Formula.factory(dep_name).installed? or outdated.include?(dep_name)
      end

      puts "#{f.name}: #{missing_deps.join(', ')}" unless missing_deps.empty?
    end
  end
end

main()
