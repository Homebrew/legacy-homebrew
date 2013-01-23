require 'build_environment'

## This file defines dependencies and requirements.
##
## A dependency is a formula that another formula needs to install.
## A requirement is something other than a formula that another formula
## needs to be present. This includes external language modules,
## command-line tools in the path, or any arbitrary predicate.
##
## The `depends_on` method in the formula DSL is used to declare
## dependencies and requirements.


# This class is used by `depends_on` in the formula DSL to turn dependency
# specifications into the proper kinds of dependencies and requirements.
class DependencyCollector
  # Define the languages that we can handle as external dependencies.
  LANGUAGE_MODULES = [
    :chicken, :jruby, :lua, :node, :ocaml, :perl, :python, :rbx, :ruby
  ].freeze

  attr_reader :deps, :requirements

  def initialize
    @deps = Dependencies.new
    @requirements = ComparableSet.new
  end

  def add spec
    tag = nil
    spec, tag = spec.shift if spec.is_a? Hash

    dep = parse_spec(spec, tag)
    # Some symbol specs are conditional, and resolve to nil if there is no
    # dependency needed for the current platform.
    return if dep.nil?
    # Add dep to the correct bucket
    (dep.is_a?(Requirement) ? @requirements : @deps) << dep
  end

private

  def parse_spec spec, tag
    case spec
    when Symbol
      parse_symbol_spec(spec, tag)
    when String
      if LANGUAGE_MODULES.include? tag
        LanguageModuleDependency.new(tag, spec)
      else
        Dependency.new(spec, tag)
      end
    when Formula
      Dependency.new(spec.name, tag)
    when Dependency, Requirement
      spec
    when Class
      if spec < Requirement
        spec.new
      else
        raise "#{spec} is not a Requirement subclass"
      end
    else
      raise "Unsupported type #{spec.class} for #{spec}"
    end
  end

  def parse_symbol_spec spec, tag
    case spec
    when :autoconf, :automake, :bsdmake, :libtool
      # Xcode no longer provides autotools or some other build tools
      Dependency.new(spec.to_s, tag) unless MacOS::Xcode.provides_autotools?
    when :libpng, :freetype, :pixman, :fontconfig, :cairo
      if MacOS.version >= :mountain_lion
        Dependency.new(spec.to_s, tag)
      else
        X11Dependency.new(tag)
      end
    when :x11
      X11Dependency.new(tag)
    when :xcode
      XcodeDependency.new(tag)
    when :mysql
      MysqlInstalled.new(tag)
    when :postgresql
      PostgresqlInstalled.new(tag)
    when :tex
      TeXInstalled.new(tag)
    when :clt
      CLTDependency.new(tag)
    else
      raise "Unsupported special dependency #{spec}"
    end
  end

end

class Dependencies
  include Enumerable

  def initialize(*args)
    @deps = Array.new(*args)
  end

  def each(*args, &block)
    @deps.each(*args, &block)
  end

  def <<(o)
    @deps << o unless @deps.include? o
    self
  end

  def empty?
    @deps.empty?
  end

  def *(arg)
    @deps * arg
  end

  def to_a
    @deps
  end
  alias_method :to_ary, :to_a
end

module Dependable
  RESERVED_TAGS = [:build, :optional, :recommended]

  def build?
    tags.include? :build
  end

  def optional?
    tags.include? :optional
  end

  def recommended?
    tags.include? :recommended
  end

  def options
    Options.coerce(tags - RESERVED_TAGS)
  end
end


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

  def universal!
    tags << 'universal' if to_formula.build.has_option? 'universal'
  end

  # Expand the dependencies of f recursively, optionally yielding
  # [f, dep] to allow callers to apply arbitrary filters to the list.
  # The default filter, which is used when a block is not supplied,
  # omits optionals and recommendeds based on what the dependent has
  # asked for.
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

  # Used to prune dependencies when calling expand_dependencies with a block.
  def self.prune
    throw(:prune, true)
  end
end

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

require 'requirements'
