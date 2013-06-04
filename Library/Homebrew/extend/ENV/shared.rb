module SharedEnvExtension
  CC_FLAG_VARS = %w{CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS}
  FC_FLAG_VARS = %w{FCFLAGS FFLAGS}

  COMPILERS = ['clang', 'gcc-4.0', 'gcc-4.2', 'llvm-gcc', /(gcc-\d\.\d)/]
  COMPLER_ALIASES = {'gcc' => 'gcc-4.2', 'llvm' => 'llvm-gcc'}
  COMPILER_SYMBOL_MAP = { 'gcc-4.0'  => :gcc_4_0,
                          'gcc-4.2'  => :gcc,
                          'llvm-gcc' => :llvm,
                          'clang'    => :clang }

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
      unless self[key].to_s.empty?
        self[key] = self[key] + separator + value
      else
        self[key] = value
      end
    end
  end
  def prepend keys, value, separator = ' '
    value = value.to_s
    Array(keys).each do |key|
      unless self[key].to_s.empty?
        self[key] = value + separator + self[key]
      else
        self[key] = value
      end
    end
  end

  def append_path key, path
    append key, path, File::PATH_SEPARATOR if File.directory? path
  end

  def prepend_path key, path
    prepend key, path, File::PATH_SEPARATOR if File.directory? path
  end

  def remove keys, value
    Array(keys).each do |key|
      next unless self[key]
      self[key] = self[key].sub(value, '')
      delete(key) if self[key].to_s.empty?
    end if value
  end

  def cc= val
    self['CC'] = self['OBJC'] = val
  end

  def cxx= val
    self['CXX'] = self['OBJCXX'] = val
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
    if (cc = ARGV.cc)
      raise("Invalid value for --cc: #{cc}") if COMPILERS.grep(cc).empty?
      COMPILER_SYMBOL_MAP.fetch(cc, cc)
    elsif ARGV.include? '--use-gcc'
      gcc_installed = Formula.factory('apple-gcc42').installed? rescue false
      # fall back to something else on systems without Apple gcc
      if MacOS.locate('gcc-4.2') || gcc_installed
        :gcc
      else
        raise "gcc-4.2 not found!"
      end
    elsif ARGV.include? '--use-llvm'
      :llvm
    elsif ARGV.include? '--use-clang'
      :clang
    elsif self['HOMEBREW_CC']
      cc = COMPLER_ALIASES.fetch(self['HOMEBREW_CC'], self['HOMEBREW_CC'])
      COMPILER_SYMBOL_MAP.fetch(cc) do |invalid|
        opoo "Invalid value for HOMEBREW_CC: #{invalid}"
        MacOS.default_compiler
      end
    else
      MacOS.default_compiler
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

    elsif (gfortran = which('gfortran', ORIGINAL_PATHS.join(File::PATH_SEPARATOR)))
      ohai "Using Homebrew-provided fortran compiler."
      puts "This may be changed by setting the FC environment variable."
      self['FC'] = self['F77'] = gfortran
      flags = FC_FLAG_VARS
    end

    flags.each { |key| self[key] = cflags }
    set_cpu_flags(flags)
  end

  def warn_about_non_apple_gcc(gcc)
    opoo "Experimental support for non-Apple GCC enabled. Some builds may fail!"

    begin
      gcc_name = 'gcc' + gcc.delete('.')
      gcc = Formula.factory(gcc_name)
      if !gcc.installed?
        raise <<-EOS.undent
        The requested Homebrew GCC, #{gcc_name}, was not installed.
        You must:
          brew tap homebrew/versions
          brew install #{gcc_name}
        EOS
      end

      ENV.append('PATH', gcc.opt_prefix/'bin', ':')
    rescue FormulaUnavailableError
      raise <<-EOS.undent
      Homebrew GCC requested, but formula #{gcc_name} not found!
      You may need to: brew tap homebrew/versions
      EOS
    end
  end
end
