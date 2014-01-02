require 'formula'
require 'tab'

module Homebrew extend self
  def missing_deps ff
    missing = {}
    ff.each do |f|
      missing_deps = f.recursive_dependencies do |dependent, dep|
        if dep.optional? || dep.recommended?
          tab = Tab.for_formula(dependent)
          Dependency.prune unless tab.with?(dep.name)
        elsif dep.build?
          Dependency.prune
        end
      end

      missing_deps.map!(&:to_formula)
      missing_deps.reject! { |d| d.rack.exist? && d.rack.subdirs.length > 0 }

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
      Formula.installed
    else
      ARGV.formulae
    end

    missing_deps(ff) do |name, missing|
      print "#{name}: " if ff.size > 1
      puts "#{missing * ' '}"
    end
  end
end
