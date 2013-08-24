module SharedEnvExtension
  CC_FLAG_VARS = %w{CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS}
  FC_FLAG_VARS = %w{FCFLAGS FFLAGS}

  COMPILERS = ['clang', 'gcc-4.0', 'gcc-4.2', 'llvm-gcc']

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

  def cc;       self['CC'];           end
  def cxx;      self['CXX'];          end
  def cflags;   self['CFLAGS'];       end
  def cxxflags; self['CXXFLAGS'];     end
  def cppflags; self['CPPFLAGS'];     end
  def ldflags;  self['LDFLAGS'];      end
  def fc;       self['FC'];           end
  def fflags;   self['FFLAGS'];       end
  def fcflags;  self['FCFLAGS'];      end

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
    # superenv removes these PATHs, but this option needs them
    # TODO fix better, probably by making a super-fc
    self['PATH'] += ":#{HOMEBREW_PREFIX}/bin:/usr/local/bin"

    if self['FC']
      ohai "Building with an alternative Fortran compiler"
      puts "This is unsupported."
      self['F77'] ||= self['FC']

      if ARGV.include? '--default-fortran-flags'
        flags_to_set = []
        flags_to_set << 'FCFLAGS' unless self['FCFLAGS']
        flags_to_set << 'FFLAGS' unless self['FFLAGS']
        flags_to_set.each {|key| self[key] = cflags}
        set_cpu_flags(flags_to_set)
      elsif not self['FCFLAGS'] or self['FFLAGS']
        opoo <<-EOS.undent
          No Fortran optimization information was provided.  You may want to consider
          setting FCFLAGS and FFLAGS or pass the `--default-fortran-flags` option to
          `brew install` if your compiler is compatible with GCC.

          If you like the default optimization level of your compiler, ignore this
          warning.
        EOS
      end

    elsif which 'gfortran'
      ohai "Using Homebrew-provided fortran compiler."
      puts "This may be changed by setting the FC environment variable."
      self['FC'] = which 'gfortran'
      self['F77'] = self['FC']

      FC_FLAG_VARS.each {|key| self[key] = cflags}
      set_cpu_flags(FC_FLAG_VARS)
    end
  end
end
