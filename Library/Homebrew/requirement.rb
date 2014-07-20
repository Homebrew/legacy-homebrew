require 'dependable'
require 'dependency'
require 'dependencies'
require 'build_environment'

# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
  include Dependable

  attr_reader :tags, :name, :option_name

  def initialize(tags=[])
    @tags = tags
    @tags << :build if self.class.build
    @name ||= infer_name
    @option_name = @name
  end

  # The message to show when the requirement is not met.
  def message; "" end

  # Overriding #satisfied? is deprecated.
  # Pass a block or boolean to the satisfy DSL method instead.
  def satisfied?
    result = self.class.satisfy.yielder { |p| instance_eval(&p) }
    @satisfied_result = result
    !!result
  end

  # Can overridden to optionally prevent a formula with this requirement from
  # pouring a bottle.
  def pour_bottle?; true end

  # Overriding #fatal? is deprecated.
  # Pass a boolean to the fatal DSL method instead.
  def fatal?
    self.class.fatal || false
  end

  def default_formula?
    self.class.default_formula || false
  end

  # Overriding #modify_build_environment is deprecated.
  # Pass a block to the the env DSL method instead.
  # Note: #satisfied? should be called before invoking this method
  # as the env modifications may depend on its side effects.
  def modify_build_environment
    instance_eval(&env_proc) if env_proc

    # XXX If the satisfy block returns a Pathname, then make sure that it
    # remains available on the PATH. This makes requirements like
    #   satisfy { which("executable") }
    # work, even under superenv where "executable" wouldn't normally be on the
    # PATH.
    # This is undocumented magic and it should be removed, but we need to add
    # a way to declare path-based requirements that work with superenv first.
    if Pathname === @satisfied_result
      parent = @satisfied_result.parent
      unless ENV["PATH"].split(File::PATH_SEPARATOR).include?(parent.to_s)
        ENV.append_path("PATH", parent)
      end
    end
  end

  def env
    self.class.env
  end

  def env_proc
    self.class.env_proc
  end

  def eql?(other)
    instance_of?(other.class) && name == other.name && tags == other.tags
  end

  def hash
    [name, *tags].hash
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect}>"
  end

  def to_dependency
    f = self.class.default_formula
    raise "No default formula defined for #{inspect}" if f.nil?
    Dependency.new(f, tags, method(:modify_build_environment), name)
  end

  private

  def infer_name
    klass = self.class.name || self.class.to_s
    klass.sub!(/(Dependency|Requirement)$/, '')
    klass.sub!(/^(\w+::)*/, '')
    klass.downcase
  end

  def which(cmd)
    super(cmd, ORIGINAL_PATHS.join(File::PATH_SEPARATOR))
  end

  class << self
    include BuildEnvironmentDSL

    attr_reader :env_proc
    attr_rw :fatal, :default_formula
    # build is deprecated, use `depends_on <requirement> => :build` instead
    attr_rw :build

    def satisfy(options={}, &block)
      @satisfied ||= Requirement::Satisfier.new(options, &block)
    end

    def env(*settings, &block)
      if block_given?
        @env_proc = block
      else
        super
      end
    end
  end

  class Satisfier
    def initialize(options={}, &block)
      case options
      when Hash
        @options = { :build_env => true }
        @options.merge!(options)
      else
        @satisfied = options
      end
      @proc = block
    end

    def yielder
      if instance_variable_defined?(:@satisfied)
        @satisfied
      elsif @options[:build_env]
        require "extend/ENV"
        ENV.with_build_environment { yield @proc }
      else
        yield @proc
      end
    end
  end

  class << self
    # Expand the requirements of dependent recursively, optionally yielding
    # [dependent, req] pairs to allow callers to apply arbitrary filters to
    # the list.
    # The default filter, which is applied when a block is not given, omits
    # optionals and recommendeds based on what the dependent has asked for.
    def expand(dependent, &block)
      reqs = Requirements.new

      formulae = dependent.recursive_dependencies.map(&:to_formula)
      formulae.unshift(dependent)

      formulae.each do |f|
        f.requirements.each do |req|
          if prune?(f, req, &block)
            next
          else
            reqs << req
          end
        end
      end

      reqs
    end

    def prune?(dependent, req, &block)
      catch(:prune) do
        if block_given?
          yield dependent, req
        elsif req.optional? || req.recommended?
          prune unless dependent.build.with?(req)
        end
      end
    end

    # Used to prune requirements when calling expand with a block.
    def prune
      throw(:prune, true)
    end
  end
end
