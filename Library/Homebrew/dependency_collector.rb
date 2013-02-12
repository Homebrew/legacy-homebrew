require 'dependency'
require 'dependencies'
require 'requirement'
require 'requirements'

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

  def add(spec)
    case dep = build(spec)
    when Dependency
      @deps << dep
    when Requirement
      @requirements << dep
    end
    dep
  end

  def build(spec)
    spec, tag = case spec
                when Hash then spec.shift
                else spec
                end

    parse_spec(spec, tag)
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
        spec.new(tag)
      else
        raise "#{spec} is not a Requirement subclass"
      end
    else
      raise "Unsupported type #{spec.class} for #{spec}"
    end
  end

  def parse_symbol_spec spec, tag
    case spec
    when :autoconf, :automake, :bsdmake, :libtool, :libltdl
      # Xcode no longer provides autotools or some other build tools
      autotools_dep(spec, tag)
    when *X11Dependency::Proxy::PACKAGES
      x11_dep(spec, tag)
    when :cairo, :pixman
      # We no longer use X11 psuedo-deps for cairo or pixman,
      # so just return a standard formula dependency.
      Dependency.new(spec.to_s, tag)
    when :x11        then X11Dependency.new(spec.to_s, tag)
    when :xcode      then XcodeDependency.new(tag)
    when :mysql      then MysqlDependency.new(tag)
    when :postgresql then PostgresqlDependency.new(tag)
    when :tex        then TeXDependency.new(tag)
    when :clt        then CLTDependency.new(tag)
    else
      raise "Unsupported special dependency #{spec}"
    end
  end

  def x11_dep(spec, tag)
    if MacOS.version >= :mountain_lion
      Dependency.new(spec.to_s, tag)
    else
      X11Dependency::Proxy.for(spec.to_s, tag)
    end
  end

  def autotools_dep(spec, tag)
    case spec
    when :libltdl then spec, tag = :libtool, Array(tag)
    else tag = Array(tag) << :build
    end

    unless MacOS::Xcode.provides_autotools?
      Dependency.new(spec.to_s, tag)
    end
  end
end
