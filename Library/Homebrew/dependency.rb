require 'dependable'

# A dependency on another Homebrew formula.
class Dependency
  include Dependable

  attr_reader :name, :tags

  def initialize(name, tags=[])
    @name = name
    @tags = tags
  end

  def to_s
    name
  end

  def ==(other)
    name == other.name
  end

  def eql?(other)
    instance_of?(other.class) && hash == other.hash
  end

  def hash
    name.hash
  end

  def to_formula
    f = Formula.factory(name)
    # Add this dependency's options to the formula's build args
    f.build.args = f.build.args.concat(options)
    f
  end

  def installed?
    to_formula.installed?
  end

  def requested?
    ARGV.formulae.include?(to_formula) rescue false
  end

  def satisfied?
    installed? && missing_options.empty?
  end

  def missing_options
    options - Tab.for_formula(to_formula).used_options - to_formula.build.implicit_options
  end

  def universal!
    tags << 'universal' if to_formula.build.has_option? 'universal'
  end

  class << self
    # Expand the dependencies of dependent recursively, optionally yielding
    # [dependent, dep] pairs to allow callers to apply arbitrary filters to
    # the list.
    # The default filter, which is applied when a block is not given, omits
    # optionals and recommendeds based on what the dependent has asked for.
    def expand(dependent, &block)
      dependent.deps.map do |dep|
        if prune?(dependent, dep, &block)
          next
        else
          expand(dep.to_formula, &block) << dep
        end
      end.flatten.compact.uniq
    end

    def prune?(dependent, dep, &block)
      catch(:prune) do
        if block_given?
          yield dependent, dep
        elsif dep.optional? || dep.recommended?
          prune unless dependent.build.with?(dep.name)
        end
      end
    end

    # Used to prune dependencies when calling expand with a block.
    def prune
      throw(:prune, true)
    end
  end
end
