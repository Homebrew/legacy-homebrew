require 'set'

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
    @requirements = Set.new
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
      Dependency.new(spec.to_s) unless MacOS::Xcode.provides_autotools?
    when :libpng, :freetype, :pixman, :fontconfig, :cairo
      if MacOS.lion_or_newer?
        MacOS::XQuartz.installed? ? X11Dependency.new(tag) : Dependency.new(spec.to_s)
      else
        X11Dependency.new(tag)
      end
    when :x11
      X11Dependency.new(tag)
    else
      raise "Unsupported special dependency #{spec}"
    end
  end

end


# A list of formula dependencies.
class Dependencies < Array
  def include? dependency_name
    self.any?{|d| d.name == dependency_name}
  end
end


# A dependency on another Homebrew formula.
class Dependency
  attr_reader :name, :tags

  def initialize name, tags=nil
    @name = name
    @tags = case tags
      when Array then tags.each {|s| s.to_s}
      when nil then []
      else [tags.to_s]
    end
  end

  def to_s
    @name
  end

  def ==(other_dep)
    @name == other_dep.to_s
  end

  def <=>(other_dep)
    @name <=> other_dep.to_s
  end

  def options
    @tags.select{|p|p.start_with? '--'}
  end
end


# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
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
    @message.hash
  end
end


# A dependency on a language-specific module.
class LanguageModuleDependency < Requirement
  def initialize language, module_name, import_name=nil
    @language = language
    @module_name = module_name
    @import_name = import_name || module_name
  end

  def fatal?; true; end

  def satisfied?
    quiet_system(*the_test)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: #{@module_name}
    Homebrew does not provide #{@language.to_s.capitalize} dependencies; install with:
      #{command_line} #{@module_name}
    EOS
  end

  def the_test
    case @language
      when :chicken then %W{/usr/bin/env csi -e (use #{@import_name})}
      when :jruby then %W{/usr/bin/env jruby -rubygems -e require\ '#{@import_name}'}
      when :lua then %W{/usr/bin/env luarocks show #{@import_name}}
      when :node then %W{/usr/bin/env node -e require('#{@import_name}');}
      when :perl then %W{/usr/bin/env perl -e use\ #{@import_name}}
      when :python then %W{/usr/bin/env python -c import\ #{@import_name}}
      when :ruby then %W{/usr/bin/env ruby -rubygems -e require\ '#{@import_name}'}
      when :rbx then %W{/usr/bin/env rbx -rubygems -e require\ '#{@import_name}'}
    end
  end

  def command_line
    case @language
      when :chicken then "chicken-install"
      when :jruby   then "jruby -S gem install"
      when :lua     then "luarocks install"
      when :node    then "npm install"
      when :perl    then "cpan -i"
      when :python  then "easy_install"
      when :rbx     then "rbx gem install"
      when :ruby    then "gem install"
    end
  end
end


# This requirement is used to require an X11 implementation,
# optionally with a minimum version number.
class X11Dependency < Requirement

  def initialize min_version=nil
    @min_version = min_version
  end

  def fatal?; true; end

  def satisfied?
    MacOS::XQuartz.installed? and (@min_version.nil? or @min_version <= MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Please install the latest version of XQuartz:
      https://xquartz.macosforge.org
    EOS
  end

  def modify_build_environment
    ENV.x11
  end

end


# There are multiple implementations of MPI-2 available.
# http://www.mpi-forum.org/
# This requirement is used to find an appropriate one.
class MPIDependency < Requirement

  attr_reader :lang_list

  def initialize *lang_list
    @lang_list = lang_list
    @non_functional = []
    @unknown_langs = []
  end

  def fatal?; true; end

  def mpi_wrapper_works? compiler
    compiler = which compiler
    return false if compiler.nil? or not compiler.executable?

    # Some wrappers are non-functional and will return a non-zero exit code
    # when invoked for version info.
    #
    # NOTE: A better test may be to do a small test compilation a la autotools.
    quiet_system compiler, '--version'
  end

  def satisfied?
    @lang_list.each do |lang|
      case lang
      when :cc, :cxx, :f90, :f77
        compiler = 'mpi' + lang.to_s
        @non_functional << compiler unless mpi_wrapper_works? compiler
      else
        @unknown_langs << lang.to_s
      end
    end

    @unknown_langs.empty? and @non_functional.empty?
  end

  def modify_build_environment
    # Set environment variables to help configure scripts find MPI compilers.
    # Variable names taken from:
    # http://www.gnu.org/software/autoconf-archive/ax_mpi.html
    lang_list.each do |lang|
      compiler = 'mpi' + lang.to_s
      mpi_path = which compiler

      # Fortran 90 environment var has a different name
      compiler = 'MPIFC' if lang == :f90
      ENV[compiler.upcase] = mpi_path
    end
  end

  def message
    if not @unknown_langs.empty?
      <<-EOS.undent
        There is no MPI compiler wrapper for:
            #{@unknown_langs.join ', '}

        The following values are valid arguments to `MPIDependency.new`:
            :cc, :cxx, :f90, :f77
        EOS
    else
      <<-EOS.undent
        Homebrew could not locate working copies of the following MPI compiler
        wrappers:
            #{@non_functional.join ', '}

        If you have a MPI installation, please ensure the bin folder is on your
        PATH and that all the wrappers are functional. Otherwise, a MPI
        installation can be obtained from homebrew by *picking one* of the
        following formulae:
            open-mpi, mpich2
        EOS
    end
  end

end

# This requirement added by the `conflicts_with` DSL method.
class ConflictRequirement < Requirement
  attr_reader :formula

  def initialize formula, message
    @formula = formula
    @message = message
  end

  def message; @message; end

  def satisfied?
    keg = Formula.factory(@formula).prefix
    not keg.exist? && Keg.new(keg).linked?
  end

  # The user can chose to force installation even in the face of conflicts.
  def fatal?
    not ARGV.force?
  end
end
