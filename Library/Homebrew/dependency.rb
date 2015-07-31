require "dependable"

# A dependency on another Homebrew formula.
class Dependency
  class DependencyMergeConflict < RuntimeError
    def initialize(formulae)
      super <<-EOS.undent
        Cannot merge dependencies, multiple conflicting formalae are requested.
         * #{formulae.join("\n * ")}
      EOS
    end
  end

  include Dependable

  attr_reader :name, :tags, :env_proc, :option_name

  # @private
  attr_accessor :owner_tap, :formula

  DEFAULT_ENV_PROC = proc {}

  def initialize(name, tags = [], env_proc = DEFAULT_ENV_PROC, option_name = name)
    @name = name
    @tags = tags
    @env_proc = env_proc
    @option_name = option_name
  end

  def to_s
    name
  end

  def ==(other)
    instance_of?(other.class) && name == other.name && tags == other.tags
  end
  alias_method :eql?, :==

  def hash
    name.hash ^ tags.hash
  end

  def to_formula
    return @formula if @formula

    if owner_tap.nil? || name =~ HOMEBREW_TAP_FORMULA_REGEX
      @formula = Formulary.factory(name)
    else
      begin
        @formula = Formulary.factory("#{owner_tap}/#{name}")
      rescue FormulaUnavailableError
        @formula = Formulary.factory(name)
        unless @formula.core_formula? or (@@warned_cross_tap_dependency ||= []).include?(name)
          provider = if owner_tap == "Homebrew/homebrew"
            "core"
          else
            "either #{owner_tap} or core"
          end
          opoo <<-EOS.undent
            #{name} is required but is not provided by #{provider}.
            We are installing from #{@formula.tap} instead.
            You may wish to contact the author of #{owner_tap} to report this.
          EOS
          @@warned_cross_tap_dependency << name
        end
      end
    end
    @formula.build = BuildOptions.new(options, @formula.options)
    @formula
  end

  def installed?
    to_formula.installed?
  end

  def satisfied?(inherited_options)
    installed? && missing_options(inherited_options).empty?
  end

  def missing_options(inherited_options)
    required = options | inherited_options
    required - Tab.for_formula(to_formula).used_options
  end

  def modify_build_environment
    env_proc.call unless env_proc.nil?
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} owner_tap=#{owner_tap.inspect}>"
  end

  # Define marshaling semantics because we cannot serialize @env_proc
  def _dump(*)
    Marshal.dump([name, tags])
  end

  def self._load(marshaled)
    new(*Marshal.load(marshaled))
  end

  class << self
    # Expand the dependencies of dependent recursively, optionally yielding
    # [dependent, dep] pairs to allow callers to apply arbitrary filters to
    # the list.
    # The default filter, which is applied when a block is not given, omits
    # optionals and recommendeds based on what the dependent has asked for.
    def expand(dependent, deps = dependent.deps, &block)
      expanded_deps = []

      deps.each do |dep|
        # FIXME: don't hide cyclic dependencies
        next if dependent.name == dep.name

        case action(dependent, dep, &block)
        when :prune
          next
        when :skip
          expanded_deps.concat(expand(dep.to_formula, &block))
        when :keep_but_prune_recursive_deps
          expanded_deps << dep
        else
          expanded_deps.concat(expand(dep.to_formula, &block))
          expanded_deps << dep
        end
      end

      merge_repeats(expanded_deps)
    end

    def action(dependent, dep, &_block)
      catch(:action) do
        if block_given?
          yield dependent, dep
        elsif dep.optional? || dep.recommended?
          prune unless dependent.build.with?(dep)
        end
      end
    end

    # Prune a dependency and its dependencies recursively
    def prune
      throw(:action, :prune)
    end

    # Prune a single dependency but do not prune its dependencies
    def skip
      throw(:action, :skip)
    end

    # Keep a dependency, but prune its dependencies
    def keep_but_prune_recursive_deps
      throw(:action, :keep_but_prune_recursive_deps)
    end

    def merge_repeats(all)
      grouped = all.group_by(&:name)

      all.map(&:name).uniq.map do |name|
        deps     = grouped.fetch(name)
        dep      = deps.first
        tags     = deps.flat_map(&:tags).uniq
        formulae = deps.flat_map(&:to_formula)
        formula  = formulae.first

        unless (formula_names = formulae.map(&:full_name).uniq).size == 1
          raise DependencyMergeConflict.new(formula_names)
        end

        merged_dep = dep.class.new(name, tags, dep.env_proc, dep.option_name)
        merged_dep.formula = formula
        merged_dep.formula.build = BuildOptions.new(merged_dep.options, formula.options)
        merged_dep
      end
    end
  end
end

class TapDependency < Dependency
  attr_reader :tap

  def initialize(name, tags = [], env_proc = DEFAULT_ENV_PROC, option_name = name.split("/").last)
    @tap = name.rpartition("/").first
    super(name, tags, env_proc, option_name)
  end

  def installed?
    super
  rescue FormulaUnavailableError
    false
  end
end
