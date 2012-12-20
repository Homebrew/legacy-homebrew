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

  def initialize(*tags)
    tags.flatten!
    @min_version = tags.shift if /(\d\.)+\d/ === tags.first
    super
  end

  def fatal?; true; end

  def satisfied?
    MacOS::XQuartz.installed? and (@min_version.nil? or @min_version <= MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Homebrew does not package XQuartz. Installers may be found at:
      https://xquartz.macosforge.org
    EOS
  end

  def modify_build_environment
    ENV.x11
  end

  def <=> other
    unless other.is_a? X11Dependency
      raise TypeError, "expected X11Dependency"
    end

    if other.min_version.nil?
      1
    elsif @min_version.nil?
      -1
    else
      @min_version <=> other.min_version
    end
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

  def initialize formula, name, opts={}
    @formula = formula
    @name = name
    @opts = opts
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

  def satisfied?
    keg = Formula.factory(@formula).prefix
    not keg.exist? && Keg.new(keg).linked?
  end

  # The user can chose to force installation even in the face of conflicts.
  def fatal?
    not ARGV.force?
  end
end

class XcodeDependency < Requirement
  def fatal?; true; end

  def satisfied?
    MacOS::Xcode.installed?
  end

  def message; <<-EOS.undent
    A full installation of Xcode.app is required to compile this software.
    Installing just the Command Line Tools is not sufficent.
    EOS
  end
end

class MysqlInstalled < Requirement
  def fatal?; true; end

  def satisfied?
    which 'mysql_config'
  end

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

class PostgresqlInstalled < Requirement
  def fatal?; true; end

  def satisfied?
    which 'pg_config'
  end

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
