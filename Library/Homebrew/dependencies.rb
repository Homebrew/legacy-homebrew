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
    :chicken, :jruby, :lua, :node, :perl, :python, :rbx, :ruby
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
    else
      raise "Unsupported special dependency #{spec}"
    end
  end

end


# A list of formula dependencies.
class Dependencies < Array
  def <<(o)
    super(o) unless include? o
  end
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
    tags.reject { |tag| RESERVED_TAGS.include? tag }.map { |tag| '--'+tag.to_s }
  end
end


# A dependency on another Homebrew formula.
class Dependency
  include Dependable

  attr_reader :name, :tags

  def initialize(name, *tags)
    @name = name
    @tags = [tags].flatten.compact
  end

  def hash
    @name.hash
  end

  def to_s
    @name
  end

  def ==(other)
    @name == other.to_s
  end

  def <=>(other)
    @name <=> other.to_s
  end

  def eql?(other)
    other.is_a? self.class and hash == other.hash
  end
end

# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
  include Dependable

  attr_reader :tags

  def initialize(*tags)
    @tags = tags.flatten.compact
  end

  # Should return true if this requirement is met.
  def satisfied?; false; end
  # Should return true if not meeting this requirement should fail the build.
  def fatal?; false; end
  # The message to show when the requirement is not met.
  def message; ""; end

  # Requirements can modify the current build environment by overriding this.
  # See X11Dependency
  def modify_build_environment; nil end

  def eql?(other)
    other.is_a? self.class and hash == other.hash
  end

  def hash
    message.hash
  end
end

require 'requirements'
