require 'dependency'
require 'dependencies'
require 'requirement'
require 'requirements'
require 'requirements/ld64_dependency'
require 'set'

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
  LANGUAGE_MODULES = Set[
    :chicken, :jruby, :lua, :node, :ocaml, :perl, :python, :rbx, :ruby
  ].freeze

  CACHE = {}

  def self.clear_cache
    CACHE.clear
  end

  attr_reader :deps, :requirements

  def initialize
    @deps = Dependencies.new
    @requirements = Requirements.new
  end

  def add(spec)
    case dep = fetch(spec)
    when Dependency
      @deps << dep
    when Requirement
      @requirements << dep
    end
    dep
  end

  def fetch(spec)
    CACHE.fetch(cache_key(spec)) { |key| CACHE[key] = build(spec) }
  end

  def cache_key(spec)
    if Resource === spec && spec.download_strategy == CurlDownloadStrategy
      File.extname(spec.url)
    else
      spec
    end
  end

  def build(spec)
    spec, tags = case spec
                 when Hash then destructure_spec_hash(spec)
                 else spec
                 end

    parse_spec(spec, Array(tags))
  end

  private

  def destructure_spec_hash(spec)
    spec.each { |o| return o }
  end

  def parse_spec(spec, tags)
    case spec
    when String
      parse_string_spec(spec, tags)
    when Resource
      resource_dep(spec, tags)
    when Symbol
      parse_symbol_spec(spec, tags)
    when Requirement, Dependency
      spec
    when Class
      parse_class_spec(spec, tags)
    else
      raise TypeError, "Unsupported type #{spec.class.name} for #{spec.inspect}"
    end
  end

  def parse_string_spec(spec, tags)
    if tags.empty?
      Dependency.new(spec, tags)
    elsif (tag = tags.first) && LANGUAGE_MODULES.include?(tag)
      LanguageModuleDependency.new(tag, spec, tags[1])
    elsif HOMEBREW_TAP_FORMULA_REGEX === spec
      TapDependency.new(spec, tags)
    else
      Dependency.new(spec, tags)
    end
  end

  def parse_symbol_spec(spec, tags)
    case spec
    when :autoconf, :automake, :bsdmake, :libtool
      # Xcode no longer provides autotools or some other build tools
      autotools_dep(spec, tags)
    when :x11        then X11Dependency.new(spec.to_s, tags)
    when :xcode      then XcodeDependency.new(tags)
    when :macos      then MinimumMacOSRequirement.new(tags)
    when :mysql      then MysqlDependency.new(tags)
    when :postgresql then PostgresqlDependency.new(tags)
    when :fortran    then FortranDependency.new(tags)
    when :mpi        then MPIDependency.new(*tags)
    when :tex        then TeXDependency.new(tags)
    when :arch       then ArchRequirement.new(tags)
    when :hg         then MercurialDependency.new(tags)
    # python2 is deprecated
    when :python, :python2 then PythonDependency.new(tags)
    when :python3    then Python3Dependency.new(tags)
    when :java       then JavaDependency.new(tags)
    # Tiger's ld is too old to properly link some software
    when :ld64       then LD64Dependency.new if MacOS.version < :leopard
    when :ant        then ant_dep(spec, tags)
    when :clt # deprecated
    when :cairo, :fontconfig, :freetype, :libpng, :pixman # deprecated
      Dependency.new(spec.to_s, tags)
    when :libltdl # deprecated
      tags << :run
      Dependency.new("libtool", tags)
    else
      raise ArgumentError, "Unsupported special dependency #{spec.inspect}"
    end
  end

  def parse_class_spec(spec, tags)
    if spec < Requirement
      spec.new(tags)
    else
      raise TypeError, "#{spec.inspect} is not a Requirement subclass"
    end
  end

  def autotools_dep(spec, tags)
    tags << :build unless tags.include? :run
    Dependency.new(spec.to_s, tags)
  end

  def ant_dep(spec, tags)
    if MacOS.version >= :mavericks
      Dependency.new(spec.to_s, tags)
    end
  end

  def resource_dep(spec, tags)
    tags << :build
    strategy = spec.download_strategy

    case
    when strategy <= CurlDownloadStrategy
      parse_url_spec(spec.url, tags)
    when strategy <= GitDownloadStrategy
      GitDependency.new(tags)
    when strategy <= MercurialDownloadStrategy
      MercurialDependency.new(tags)
    when strategy <= FossilDownloadStrategy
      Dependency.new("fossil", tags)
    when strategy <= BazaarDownloadStrategy
      Dependency.new("bazaar", tags)
    when strategy <= CVSDownloadStrategy
      Dependency.new("cvs", tags) if MacOS.version >= :mavericks || !MacOS::Xcode.provides_cvs?
    when strategy < AbstractDownloadStrategy
      # allow unknown strategies to pass through
    else
      raise TypeError,
        "#{strategy.inspect} is not an AbstractDownloadStrategy subclass"
    end
  end

  def parse_url_spec(url, tags)
    case File.extname(url)
    when '.xz'  then Dependency.new('xz', tags)
    when '.lz'  then Dependency.new('lzip', tags)
    when '.rar' then Dependency.new('unrar', tags)
    when '.7z'  then Dependency.new('p7zip', tags)
    end
  end
end
