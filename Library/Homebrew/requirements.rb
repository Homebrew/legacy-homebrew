require 'requirement'
require 'extend/set'

# A dependency on a language-specific module.
class LanguageModuleDependency < Requirement
  fatal true

  def initialize language, module_name, import_name=nil
    @language = language
    @module_name = module_name
    @import_name = import_name || module_name
    super
  end

  satisfy { quiet_system(*the_test) }

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
      when :ocaml then %W{/usr/bin/env opam list #{@import_name} | grep #{@import_name}}
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
      when :ocaml   then "opam install"
      when :perl    then "cpan -i"
      when :python  then "pip install"
      when :rbx     then "rbx gem install"
      when :ruby    then "gem install"
    end
  end
end


# This requirement is used to require an X11 implementation,
# optionally with a minimum version number.
class X11Dependency < Requirement
  include Comparable
  attr_reader :min_version

  fatal true

  env { x11 }

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


# There are multiple implementations of MPI-2 available.
# http://www.mpi-forum.org/
# This requirement is used to find an appropriate one.
class MPIDependency < Requirement

  attr_reader :lang_list

  fatal true

  env :userpaths

  def initialize *lang_list
    @lang_list = lang_list
    @non_functional = []
    @unknown_langs = []
    super()
  end

  def mpi_wrapper_works? compiler
    compiler = which compiler
    return false if compiler.nil? or not compiler.executable?

    # Some wrappers are non-functional and will return a non-zero exit code
    # when invoked for version info.
    #
    # NOTE: A better test may be to do a small test compilation a la autotools.
    quiet_system compiler, '--version'
  end

  satisfy do
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

  env do |req|
    # Set environment variables to help configure scripts find MPI compilers.
    # Variable names taken from:
    # http://www.gnu.org/software/autoconf-archive/ax_mpi.html
    req.lang_list.each do |lang|
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

  # The user can chose to force installation even in the face of conflicts.
  fatal !ARGV.force?

  def initialize formula, name, opts={}
    @formula = formula
    @name = name
    @opts = opts
    super(formula)
  end

  def message
    message = "#{@name.downcase} cannot be installed alongside #{@formula}.\n"
    message << "This is because #{@opts[:because]}\n" if @opts[:because]
    message << <<-EOS.undent unless ARGV.force?
      Please `brew unlink #{@formula}` before continuing. Unlinking removes
      the formula's symlinks from #{HOMEBREW_PREFIX}. You can link the
      formula again after the install finishes. You can --force this install
      but the build may fail or cause obscure side-effects in the end-binary.
    EOS
    message
  end

  satisfy :build_env => false do
    keg = Formula.factory(@formula).prefix
    not keg.exist? && Keg.new(keg).linked?
  end
end

class XcodeDependency < Requirement
  fatal true
  build true

  satisfy(:build_env => false) { MacOS::Xcode.installed? }

  def message; <<-EOS.undent
    A full installation of Xcode.app is required to compile this software.
    Installing just the Command Line Tools is not sufficent.
    EOS
  end
end

class MysqlDependency < Requirement
  fatal true

  satisfy { which 'mysql_config' }

  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install mysql
        For MySQL server.

    Or you can use an official installer from:
      http://dev.mysql.com/downloads/mysql/
    EOS
  end
end

class PostgresqlDependency < Requirement
  fatal true

  satisfy { which 'pg_config' }

  def message
    <<-EOS.undent
      Postgres is required to install.

      You can install this with Homebrew using:
        brew install postgres

      Or you can use an official installer from:
        http://www.postgresql.org/download/macosx/
    EOS
  end
end

class TeXDependency < Requirement
  fatal true

  satisfy { which('tex') || which('latex') }

  def message; <<-EOS.undent
    A LaTeX distribution is required to install.

    You can install MacTeX distribution from:
      http://www.tug.org/mactex/

    Make sure that its bin directory is in your PATH before proceeding.

    You may also need to restore the ownership of Homebrew install:
      sudo chown -R $USER `brew --prefix`
    EOS
  end
end

class CLTDependency < Requirement
  fatal true
  build true

  def satisfied?
    MacOS::CLT.installed?
  end

  def message; <<-EOS.undent
    The Command Line Tools for Xcode are required to compile this software.
    The standalone package can be obtained from http://connect.apple.com,
    or it can be installed via Xcode's preferences.
    EOS
  end
end
