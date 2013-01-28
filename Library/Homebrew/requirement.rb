require 'dependable'
require 'build_environment'

# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
  include Dependable
  extend BuildEnvironmentDSL

  attr_reader :tags

  def initialize(*tags)
    @tags = tags.flatten.compact
    @tags << :build if self.class.build
  end

  # The message to show when the requirement is not met.
  def message; "" end

  # Overriding #satisfied? is deprepcated.
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
    other.is_a?(self.class) && hash == other.hash
  end

  def hash
    message.hash
  end

  private

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
end
