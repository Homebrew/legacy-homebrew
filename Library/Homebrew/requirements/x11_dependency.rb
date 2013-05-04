require 'requirement'
require 'extend/set'

class X11Dependency < Requirement
  include Comparable
  attr_reader :min_version

  fatal true

  env { ENV.x11 }

  def initialize(name="x11", *tags)
    tags.flatten!
    @name = name
    @min_version = tags.shift if /(\d\.)+\d/ === tags.first
    super(tags)
  end

  satisfy :build_env => false do
    MacOS::XQuartz.installed? && (@min_version.nil? || @min_version <= MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Homebrew does not package XQuartz. Installers may be found at:
      https://xquartz.macosforge.org
    EOS
  end

  def <=> other
    unless other.is_a? X11Dependency
      raise TypeError, "expected X11Dependency"
    end

    if min_version.nil? && other.min_version.nil?
      0
    elsif other.min_version.nil?
      1
    elsif @min_version.nil?
      -1
    else
      @min_version <=> other.min_version
    end
  end

  # When X11Dependency is subclassed, the new class should
  # also inherit the information specified in the DSL above.
  def self.inherited(mod)
    instance_variables.each do |ivar|
      mod.instance_variable_set(ivar, instance_variable_get(ivar))
    end
  end

  # X11Dependency::Proxy is a base class for the X11 pseudo-deps.
  # Rather than instantiate it directly, a separate class is built
  # for each of the packages that we proxy to X11Dependency.
  class Proxy < self
    PACKAGES = [:libpng, :freetype, :fontconfig]

    class << self
      def defines_const?(const)
        if ::RUBY_VERSION >= "1.9"
          const_defined?(const, false)
        else
          const_defined?(const)
        end
      end

      def for(name, *tags)
        constant = name.capitalize

        if defines_const?(constant)
          klass = const_get(constant)
        else
          klass = Class.new(self) do
            def initialize(name, *tags) super end
          end

          const_set(constant, klass)
        end
        klass.new(name, *tags)
      end
    end
  end
end
