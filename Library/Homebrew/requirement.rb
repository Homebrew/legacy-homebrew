require 'dependable'
require 'build_environment'

# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
  include Dependable
  extend BuildEnvironmentDSL

  attr_reader :tags, :name

  def initialize(*tags)
    @tags = tags.flatten.compact
    @tags << :build if self.class.build
    @name ||= infer_name
  end

  # The message to show when the requirement is not met.
  def message; "" end

  # Overriding #satisfied? is deprecated.
  # Pass a block or boolean to the satisfied DSL method instead.
  def satisfied?
    result = self.class.satisfy.yielder do |proc|
      instance_eval(&proc)
    end

    infer_env_modification(result)
    !!result
  end

  # Overriding #fatal? is deprecated.
  # Pass a boolean to the fatal DSL method instead.
  def fatal?
    self.class.fatal || false
  end

  # Overriding #modify_build_environment is deprecated.
  # Pass a block to the the env DSL method instead.
  def modify_build_environment
    satisfied? and env.modify_build_environment(self)
  end

  def env
    @env ||= self.class.env
  end

  def eql?(other)
    instance_of?(other.class) && hash == other.hash
  end

  def hash
    [name, *tags].hash
  end

  private

  def infer_name
    klass = self.class.to_s
    klass.sub!(/(Dependency|Requirement)$/, '')
    klass.sub!(/^(\w+::)*/, '')
    klass.downcase
  end

  def infer_env_modification(o)
    case o
    when Pathname
      self.class.env do
        unless ENV["PATH"].split(":").include?(o.parent.to_s)
          append("PATH", o.parent, ":")
        end
      end
    end
  end

  class << self
    def fatal(val=nil)
      val.nil? ? @fatal : @fatal = val
    end

    def build(val=nil)
      val.nil? ? @build : @build = val
    end

    def satisfy(options={}, &block)
      @satisfied ||= Requirement::Satisfier.new(options, &block)
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
        require 'superenv'
        ENV.with_build_environment do
          ENV.userpaths!
          yield @proc
        end
      else
        yield @proc
      end
    end
  end

  # Expand the requirements of dependent recursively, optionally yielding
  # [dependent, req] pairs to allow callers to apply arbitrary filters to
  # the list.
  # The default filter, which is applied when a block is not given, omits
  # optionals and recommendeds based on what the dependent has asked for.
  def self.expand(dependent, &block)
    reqs = ComparableSet.new

    formulae = dependent.recursive_dependencies.map(&:to_formula)
    formulae.unshift(dependent)

    formulae.map(&:requirements).each do |requirements|
      requirements.each do |req|
        prune = catch(:prune) do
          if block_given?
            yield dependent, req
          elsif req.optional? || req.recommended?
            Requirement.prune unless dependent.build.with?(req.name)
          end
        end

        next if prune

        reqs << req
      end
    end

    # We special case handling of X11Dependency and its subclasses to
    # ensure the correct dependencies are present in the final list.
    # If an X11Dependency is present after filtering, we eliminate
    # all X11Dependency::Proxy objects from the list. If there aren't
    # any X11Dependency objects, then we eliminate all but one of the
    # proxy objects.
    proxy = unless reqs.any? { |r| r.instance_of?(X11Dependency) }
      reqs.find { |r| r.kind_of?(X11Dependency::Proxy) }
    end

    reqs.reject! do |r|
      r.kind_of?(X11Dependency::Proxy)
    end

    reqs << proxy unless proxy.nil?
    reqs
  end

  # Used to prune requirements when calling expand with a block.
  def self.prune
    throw(:prune, true)
  end
end
