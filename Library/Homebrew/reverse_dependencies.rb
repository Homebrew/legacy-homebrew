require 'formula'
require 'dependencies'

class ReverseDependencies
  attr_reader :formula

  def initialize(formula)
    @formula = formula
  end

  def to_s
    @formula.name
  end

  def all installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end

  def build installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.build.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end

  def recommended installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.recommended.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end

  def optional installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.optional.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end

  def required installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.required.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end

  def runtime installed=true
    Formula.select do |f|
      deps = Dependencies.new(f.deps)
      deps.runtime.any? do |dep|
        if installed
          f.installed? and dep.name == @formula.name
        else
          dep.name == @formula.name
        end
      end
    end
  end
end
