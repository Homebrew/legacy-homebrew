require "formula"
require "tab"

module Homebrew
  def missing_deps(ff)
    missing = {}
    ff.each do |f|
      missing_deps = f.recursive_dependencies do |dependent, dep|
        if dep.optional? || dep.recommended?
          tab = Tab.for_formula(dependent)
          Dependency.prune unless tab.with?(dep)
        elsif dep.build?
          Dependency.prune
        end
      end

      missing_deps.map!(&:to_formula)
      missing_deps.reject! { |d| d.rack.exist? && d.rack.subdirs.length > 0 }

      unless missing_deps.empty?
        yield f.full_name, missing_deps if block_given?
        missing[f.full_name] = missing_deps
      end
    end
    missing
  end

  def missing
    return unless HOMEBREW_CELLAR.exist?

    ff = if ARGV.named.empty?
      Formula.installed
    else
      ARGV.resolved_formulae
    end

    missing_deps(ff) do |name, missing|
      print "#{name}: " if ff.size > 1
      puts "#{missing * " "}"
    end
  end
end
