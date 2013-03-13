require 'dependable'

# A dependency on another Homebrew formula.
class Dependency
  include Dependable

  attr_reader :name, :tags

  def initialize(name, *tags)
    @name = name
    @tags = tags.flatten.compact
  end

  def to_s
    name
  end

  def ==(other)
    name == other.name
  end

  def eql?(other)
    other.is_a?(self.class) && hash == other.hash
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
    options - Tab.for_formula(to_formula).used_options
  end

  def universal!
    tags << 'universal' if to_formula.build.has_option? 'universal'
  end

  # Expand the dependencies of dependent recursively, optionally yielding
  # [dependent, dep] pairs to allow callers to apply arbitrary filters to
  # the list.
  # The default filter, which is applied when a block is not given, omits
  # optionals and recommendeds based on what the dependent has asked for.
  def self.expand(dependent, &block)
    dependent.deps.map do |dep|
      prune = catch(:prune) do
        if block_given?
          yield dependent, dep
        elsif dep.optional? || dep.recommended?
          Dependency.prune unless dependent.build.with?(dep.name)
        end
      end

      next if prune

      expand(dep.to_formula, &block) << dep
    end.flatten.compact.uniq
  end

  # Used to prune dependencies when calling expand with a block.
  def self.prune
    throw(:prune, true)
  end
end
