require "formula"
require "compilers"

module SharedEnvExtension
  include CompilerConstants

  CC_FLAG_VARS = %w{CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS}
  FC_FLAG_VARS = %w{FCFLAGS FFLAGS}

  COMPILER_SYMBOL_MAP = {
    "gcc-4.0"  => :gcc_4_0,
    "gcc-4.2"  => :gcc,
    "llvm-gcc" => :llvm,
    "clang"    => :clang,
  }

  COMPILERS = COMPILER_SYMBOL_MAP.values +
    GNU_GCC_VERSIONS.map { |n| "gcc-4.#{n}" }

  SANITIZED_VARS = %w[
    CDPATH GREP_OPTIONS CLICOLOR_FORCE
    CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH
    CC CXX OBJC OBJCXX CPP MAKE LD LDSHARED
    CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS
    MACOSX_DEPLOYMENT_TARGET SDKROOT DEVELOPER_DIR
    CMAKE_PREFIX_PATH CMAKE_INCLUDE_PATH CMAKE_FRAMEWORK_PATH
  ]

  def reset
    SANITIZED_VARS.each { |k| delete(k) }
  end

  def remove_cc_etc
    keys = %w{CC CXX OBJC OBJCXX LD CPP CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS}
    removed = Hash[*keys.map{ |key| [key, self[key]] }.flatten]
    keys.each do |key|
      delete(key)
    end
    removed
  end
  def append_to_cflags newflags
    append(CC_FLAG_VARS, newflags)
  end
  def remove_from_cflags val
    remove CC_FLAG_VARS, val
  end
  def append keys, value, separator = ' '
    value = value.to_s
    Array(keys).each do |key|
      old = self[key]
      if old.nil? || old.empty?
        self[key] = value
      else
        self[key] += separator + value
      end
    end
  end
  def prepend keys, value, separator = ' '
    value = value.to_s
    Array(keys).each do |key|
      old = self[key]
      if old.nil? || old.empty?
        self[key] = value
      else
        self[key] = value + separator + old
      end
    end
  end

  def append_path key, path
    append key, path, File::PATH_SEPARATOR if File.directory? path
  end

  def prepend_path key, path
    prepend key, path, File::PATH_SEPARATOR if File.directory? path
  end

  def prepend_create_path key, path
    path = Pathname.new(path) unless path.is_a? Pathname
    path.mkpath
    prepend_path key, path
  end

  def remove keys, value
    Array(keys).each do |key|
      next unless self[key]
      self[key] = self[key].sub(value, '')
      delete(key) if self[key].empty?
    end if value
  end

  def cc;       self['CC'];           end
  def cxx;      self['CXX'];          end
  def cflags;   self['CFLAGS'];       end
  def cxxflags; self['CXXFLAGS'];     end
  def cppflags; self['CPPFLAGS'];     end
  def ldflags;  self['LDFLAGS'];      end
  def fc;       self['FC'];           end
  def fflags;   self['FFLAGS'];       end
  def fcflags;  self['FCFLAGS'];      end

  def compiler
    @compiler ||= if (cc = ARGV.cc || homebrew_cc)
      COMPILER_SYMBOL_MAP.fetch(cc) do |other|
        case other
        when GNU_GCC_REGEXP
          other
        else
          raise "Invalid value for --cc: #{other}"
        end
      end
    else
      MacOS.default_compiler
    end
  end

  def determine_cc
    COMPILER_SYMBOL_MAP.invert.fetch(compiler, compiler)
  end

  COMPILERS.each do |compiler|
    define_method(compiler) do
      @compiler = compiler
      self.cc  = determine_cc
      self.cxx = determine_cxx
    end
  end

  # If the given compiler isn't compatible, will try to select
  # an alternate compiler, altering the value of environment variables.
  # If no valid compiler is found, raises an exception.
  def validate_cc!(formula)
    # FIXME
    # The compiler object we pass to fails_with? has no version information
    # attached to it. This means that if we pass Compiler.new(:clang), the
    # selector will be invoked if the formula fails with any version of clang.
    # I think we can safely remove this conditional and always invoke the
    # selector.
    # The compiler priority logic in compilers.rb and default_compiler logic in
    # os/mac.rb need to be unified somehow.
    if formula.fails_with? Compiler.new(compiler)
      send CompilerSelector.new(formula).compiler
    end
  end

  # Snow Leopard defines an NCURSES value the opposite of most distros
  # See: http://bugs.python.org/issue6848
  # Currently only used by aalib in core
  def ncurses_define
    append 'CPPFLAGS', "-DNCURSES_OPAQUE=0"
  end

  def userpaths!
    paths = ORIGINAL_PATHS.map { |p| p.realpath.to_s rescue nil } - %w{/usr/X11/bin /opt/X11/bin}
    self['PATH'] = paths.unshift(*self['PATH'].split(File::PATH_SEPARATOR)).uniq.join(File::PATH_SEPARATOR)
    # XXX hot fix to prefer brewed stuff (e.g. python) over /usr/bin.
    prepend_path 'PATH', HOMEBREW_PREFIX/'bin'
  end

  def fortran
    flags = []

    if fc
      ohai "Building with an alternative Fortran compiler"
      puts "This is unsupported."
      self['F77'] ||= fc

      if ARGV.include? '--default-fortran-flags'
        flags = FC_FLAG_VARS.reject { |key| self[key] }
      elsif values_at(*FC_FLAG_VARS).compact.empty?
        opoo <<-EOS.undent
          No Fortran optimization information was provided.  You may want to consider
          setting FCFLAGS and FFLAGS or pass the `--default-fortran-flags` option to
          `brew install` if your compiler is compatible with GCC.

          If you like the default optimization level of your compiler, ignore this
          warning.
        EOS
      end

    else
      if (gfortran = which('gfortran', (HOMEBREW_PREFIX/'bin').to_s))
        ohai "Using Homebrew-provided fortran compiler."
      elsif (gfortran = which('gfortran', ORIGINAL_PATHS.join(File::PATH_SEPARATOR)))
        ohai "Using a fortran compiler found at #{gfortran}."
      end
      if gfortran
        puts "This may be changed by setting the FC environment variable."
        self['FC'] = self['F77'] = gfortran
        flags = FC_FLAG_VARS
      end
    end

    flags.each { |key| self[key] = cflags }
    set_cpu_flags(flags)
  end

  # ld64 is a newer linker provided for Xcode 2.5
  def ld64
    ld64 = Formulary.factory('ld64')
    self['LD'] = ld64.bin/'ld'
    append "LDFLAGS", "-B#{ld64.bin}/"
  end

  def gcc_version_formula(version)
    gcc_name = "gcc-#{version}"
    gcc_version_name = "gcc#{version.delete('.')}"

    gcc_path = HOMEBREW_PREFIX.join "opt/gcc/bin/#{gcc_name}"
    gcc_formula = Formulary.factory "gcc"
    gcc_versions_path = \
      HOMEBREW_PREFIX.join "opt/#{gcc_version_name}/bin/#{gcc_name}"

    if gcc_path.exist?
      gcc_formula
    elsif gcc_versions_path.exist?
      Formulary.factory gcc_version_name
    elsif gcc_formula.version.to_s.include?(version)
      gcc_formula
    elsif (gcc_versions_formula = Formulary.factory(gcc_version_name) rescue nil)
      gcc_versions_formula
    else
      gcc_formula
    end
  end

  def warn_about_non_apple_gcc(gcc)
    gcc_name = 'gcc' + gcc.delete('.')

    begin
      gcc_formula = gcc_version_formula(gcc)
      if gcc_formula.name == "gcc"
        return if gcc_formula.opt_prefix.exist?
        raise <<-EOS.undent
        The Homebrew GCC was not installed.
        You must:
          brew install gcc
        EOS
      end

      if !gcc_formula.opt_prefix.exist?
        raise <<-EOS.undent
        The requested Homebrew GCC, #{gcc_name}, was not installed.
        You must:
          brew tap homebrew/versions
          brew install #{gcc_name}
        EOS
      end
    rescue FormulaUnavailableError
      raise <<-EOS.undent
      Homebrew GCC requested, but formula #{gcc_name} not found!
      You may need to: brew tap homebrew/versions
      EOS
    end
  end

  def permit_arch_flags; end

  private

  def cc= val
    self["CC"] = self["OBJC"] = val.to_s
  end

  def cxx= val
    self["CXX"] = self["OBJCXX"] = val.to_s
  end

  def homebrew_cc
    self["HOMEBREW_CC"]
  end
end
