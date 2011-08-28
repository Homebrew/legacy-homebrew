module HomebrewEnvExtension
  # -w: keep signal to noise high
  SAFE_CFLAGS_FLAGS = "-w -pipe"

  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    delete('CDPATH')
    delete('CPPFLAGS')
    delete('LDFLAGS')

    self['MAKEFLAGS'] = "-j#{self.make_jobs}"

    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      # /usr/local is already an -isystem and -L directory so we skip it
      self['CPPFLAGS'] = "-isystem #{HOMEBREW_PREFIX}/include"
      self['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
    end

    # llvm allows -O4 however it often fails to link and is very slow
    cflags = ['-O3']

    # If these aren't set, many formulae fail to build
    self['CC'] = '/usr/bin/cc'
    self['CXX'] = '/usr/bin/c++'

    case self.compiler
      when :clang then self.clang
      when :llvm then self.llvm
      when :gcc then self.gcc
    end

    # In rare cases this may break your builds, as the tool for some reason wants
    # to use a specific linker. However doing this in general causes formula to
    # build more successfully because we are changing CC and many build systems
    # don't react properly to that.
    self['LD'] = self['CC']

    # Optimise all the way to eleven, references:
    # http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
    # http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
    # http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
    # We don't set, eg. -msse3 because the march flag does that for us:
    # http://gcc.gnu.org/onlinedocs/gcc-4.3.3/gcc/i386-and-x86_002d64-Options.html
    if MACOS_VERSION >= 10.6
      case Hardware.intel_family
      when :nehalem, :penryn, :core2, :arrandale
        # the 64 bit compiler adds -mfpmath=sse for us
        cflags << "-march=core2"
      when :core
        cflags<<"-march=prescott"<<"-mfpmath=sse"
      else
        # note that this didn't work on older versions of Xcode's gcc
        # and maybe still doesn't. But it's at least not worse than nothing.
        # UPDATE with Xcode 4.1 doesn't work at all.
        # TODO there must be something useful!?
        #cflags << "-march=native"
      end
      # gcc doesn't auto add msse4 or above (based on march flag) yet
      case Hardware.intel_family
      when :nehalem
        cflags << "-msse4" # means msse4.2 and msse4.1
      when :penryn
        cflags << "-msse4.1"
      end
    else
      # gcc 4.0 didn't support msse4
      case Hardware.intel_family
      when :nehalem, :penryn, :core2
        cflags<<"-march=nocona"
      when :core
        cflags<<"-march=prescott"
      end
      cflags<<"-mfpmath=sse"
    end

    self['CFLAGS'] = self['CXXFLAGS'] = "#{cflags*' '} #{SAFE_CFLAGS_FLAGS}"
  end

  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  alias_method :j1, :deparallelize

  # recommended by Apple, but, eg. wget won't compile with this flag, so…
  def fast
    remove_from_cflags(/-O./)
    append_to_cflags '-fast'
  end
  def O4
    # LLVM link-time optimization
    remove_from_cflags(/-O./)
    append_to_cflags '-O4'
  end
  def O3
    # Sometimes O4 just takes fucking forever
    remove_from_cflags(/-O./)
    append_to_cflags '-O3'
  end
  def O2
    # Sometimes O3 doesn't work or produces bad binaries
    remove_from_cflags(/-O./)
    append_to_cflags '-O2'
  end
  def Os
    # Sometimes you just want a small one
    remove_from_cflags(/-O./)
    append_to_cflags '-Os'
  end
  def Og
    # Sometimes you want a debug build
    remove_from_cflags(/-O./)
    append_to_cflags '-g -O0'
  end

  def gcc_4_0_1
    self['CC'] = self['LD'] = '/usr/bin/gcc-4.0'
    self['CXX'] = '/usr/bin/g++-4.0'
    self.O3
    remove_from_cflags '-march=core2'
    remove_from_cflags %r{-msse4(\.\d)?}
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  def gcc
    if MacOS.xcode_version < '4'
      self['CC'] = '/usr/bin/cc'
      self['CXX'] = '/usr/bin/c++'
    else
      # With Xcode4 cc, c++, gcc and g++ are actually symlinks to llvm-gcc
      self['CC']  = "#{MacOS.xcode_prefix}/usr/bin/gcc-4.2"
      self['CXX'] = "#{MacOS.xcode_prefix}/usr/bin/g++-4.2"
    end
    remove_from_cflags '-O4'
  end
  alias_method :gcc_4_2, :gcc

  def llvm
    if MacOS.xcode_version < '4'
      self.gcc
    elsif MacOS.xcode_version < '4.1'
      self['CC'] = "#{MacOS.xcode_prefix}/usr/bin/llvm-gcc"
      self['CXX'] = "#{MacOS.xcode_prefix}/usr/bin/llvm-g++"
    else
      self['CC'] = '/usr/bin/cc'
      self['CXX'] = '/usr/bin/c++'
    end
  end

  def clang
    if MacOS.xcode_version > '4'
      self['CC'] = "#{MacOS.xcode_prefix}/usr/bin/clang"
      self['CXX'] = "#{MacOS.xcode_prefix}/usr/bin/clang++"
    else
      self.gcc
    end
  end

  def fortran
    if self['FC']
      ohai "Building with an alternative Fortran compiler. This is unsupported."
      self['F77'] = self['FC'] unless self['F77']

      if ARGV.include? '--default-fortran-flags'
        self['FCFLAGS'] = self['CFLAGS'] unless self['FCFLAGS']
        self['FFFLAGS'] = self['CFLAGS'] unless self['FFFLAGS']
      elsif not self['FCFLAGS'] or self['FFLAGS']
        opoo <<-EOS
No Fortran optimization information was provided.  You may want to consider
setting FCFLAGS and FFLAGS or pass the `--default-fortran-flags` option to
`brew install` if your compiler is compatible with GCC.

If you like the default optimization level of your compiler, ignore this
warning.
        EOS
      end

    elsif `/usr/bin/which gfortran`.chomp.size > 0
      ohai <<-EOS
Using Homebrew-provided fortran compiler.
    This may be changed by setting the FC environment variable.
      EOS
      self['FC'] = `/usr/bin/which gfortran`.chomp
      self['F77'] = self['FC']

      self['FCFLAGS'] = self['CFLAGS']
      self['FFLAGS'] = self['CFLAGS']

    else
      onoe <<-EOS
This formula requires a fortran compiler, but we could not find one by
looking at the FC environment variable or searching your PATH for `gfortran`.
Please take one of the following actions:

  - Decide to use the build of gfortran 4.2.x provided by Homebrew using
        `brew install gfortran`

  - Choose another Fortran compiler by setting the FC environment variable:
        export FC=/path/to/some/fortran/compiler
    Using an alternative compiler may produce more efficient code, but we will
    not be able to provide support for build errors.
      EOS
      exit 1
    end
  end

  def osx_10_4
    self['MACOSX_DEPLOYMENT_TARGET']="10.4"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.4')
  end
  def osx_10_5
    self['MACOSX_DEPLOYMENT_TARGET']="10.5"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.5')
  end

  def minimal_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = "-Os #{SAFE_CFLAGS_FLAGS}"
  end
  def no_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = SAFE_CFLAGS_FLAGS
  end

  # Some configure scripts won't find libxml2 without help
  def libxml2
    append_to_cflags '-I/usr/include/libxml2'
  end

  def x11
    opoo "You do not have X11 installed, this formula may not build." if not MacOS.x11_installed?

    # There are some config scripts (e.g. freetype) here that should go in the path
    prepend 'PATH', '/usr/X11/bin', ':'
    # CPPFLAGS are the C-PreProcessor flags, *not* C++!
    append 'CPPFLAGS', '-I/usr/X11/include'
    append 'LDFLAGS', '-L/usr/X11/lib'
    # CMake ignores the variables above
    append 'CMAKE_PREFIX_PATH', '/usr/X11', ':'
  end
  alias_method :libpng, :x11

  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags '-w'
  end

  # Snow Leopard defines an NCURSES value the opposite of most distros
  # See: http://bugs.python.org/issue6848
  def ncurses_define
    append 'CPPFLAGS', "-DNCURSES_OPAQUE=0"
  end

  # Shortcuts for reading common flags
  def cc;      self['CC'] or "gcc";  end
  def cxx;     self['CXX'] or "g++"; end
  def cflags;  self['CFLAGS'];       end
  def cppflags;self['CPPLAGS'];      end
  def ldflags; self['LDFLAGS'];      end

  def m64
    append_to_cflags '-m64'
    append 'LDFLAGS', '-arch x86_64'
  end
  def m32
    append_to_cflags '-m32'
    append 'LDFLAGS', '-arch i386'
  end

  # i386 and x86_64 (no PPC)
  def universal_binary
    append_to_cflags '-arch i386 -arch x86_64'
    self.O3 if self['CFLAGS'].include? '-O4' # O4 seems to cause the build to fail
    append 'LDFLAGS', '-arch i386 -arch x86_64'

    # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
    remove_from_cflags(/-march=\S*/) if Hardware.is_32_bit?
  end

  def prepend key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = value + separator + self[key]
    else
      self[key] = value
    end
  end

  def append key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = self[key] + separator + value
    else
      self[key] = value
    end
  end

  def append_to_cflags f
    append 'CFLAGS', f
    append 'CXXFLAGS', f
  end
  def remove key, value
    return if self[key].nil?
    self[key] = self[key].sub value, '' # can't use sub! on ENV
    self[key] = nil if self[key].empty? # keep things clean
  end
  def remove_from_cflags f
    remove 'CFLAGS', f
    remove 'CXXFLAGS', f
  end

  def compiler
    # TODO seems that ENV.clang in a Formula.install should warn when called
    # if the user has set something that is tested here

    # test for --flags first so that installs can be overridden on a per
    # install basis
    if ARGV.include? '--use-gcc'
      :gcc
    elsif ARGV.include? '--use-llvm'
      :llvm
    elsif ARGV.include? '--use-clang'
      :clang
    end

    # test for ENVs in inverse order to flags, this is sensible, trust me
    if self['HOMEBREW_USE_CLANG']
      :clang
    elsif self['HOMEBREW_USE_LLVM']
      :llvm
    elsif self['HOMEBREW_USE_GCC']
      :gcc
    else
      :gcc
    end
  end

  # don't use in new code
  # don't remove though, but do add to compatibility.rb
  def use_clang?
    compiler == :clang
  end
  def use_gcc?
    compiler == :gcc
  end
  def use_llvm?
    compiler == :llvm
  end

  def make_jobs
    # '-j' requires a positive integral argument
    if self['HOMEBREW_MAKE_JOBS'].to_i > 0
      self['HOMEBREW_MAKE_JOBS']
    else
      Hardware.processor_count
    end
  end
end
