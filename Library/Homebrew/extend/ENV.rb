#
# extend/ENV.rb - ENV extensions to help with build configuration.
#

module HomebrewEnvExtension
  # -w: suppress all warnings
  # -pipe: use pipes instead of temporary files
  SAFE_CFLAGS = "-w -pipe"

  #
  # Set up the default build settings. This works for most formulae.
  #
  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    delete('CDPATH')
    delete('CPPFLAGS')
    delete('LDFLAGS')

    self['MAKEFLAGS']="-j#{Hardware.processor_count}"

    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      # /usr/local is already an -isystem and -L directory so we skip it
      self['CPPFLAGS'] = "-isystem #{HOMEBREW_PREFIX}/include"
      self['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
    end

    if MACOS_VERSION >= 10.6 and (self['HOMEBREW_USE_LLVM'] or ARGV.include? '--use-llvm')
      xcode_path = `/usr/bin/xcode-select -print-path`.chomp
      xcode_path = "/Developer" if xcode_path.to_s.empty?
      self['CC'] = "#{xcode_path}/usr/bin/llvm-gcc"
      self['CXX'] = "#{xcode_path}/usr/bin/llvm-g++"
      cflags = ['-O4'] # link time optimisation baby!
    else
      # If these aren't set, many formulae fail to build
      self['CC'] = '/usr/bin/cc'
      self['CXX'] = '/usr/bin/c++'
      cflags = ['-O3']
    end

    # In rare cases this may break your builds, as the tool for some reason wants
    # to use a specific linker. However doing this in general causes formula to
    # build more successfully because we are changing CC and many build systems
    # don't react properly to that.
    self['LD'] = self['CC']

    # optimise all the way to eleven, references:
    # http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
    # http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
    # http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
    # we don't set, eg. -msse3 because the march flag does that for us
    #   http://gcc.gnu.org/onlinedocs/gcc-4.3.3/gcc/i386-and-x86_002d64-Options.html
    if MACOS_VERSION >= 10.6
      case Hardware.intel_family
      when :nehalem, :penryn, :core2
        # the 64 bit compiler adds -mfpmath=sse for us
        cflags << "-march=core2"
      when :core
        cflags << "-march=prescott" << "-mfpmath=sse"
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
        cflags << "-march=nocona"
      when :core
        cflags << "-march=prescott"
      end
      cflags << "-mfpmath=sse"
    end

    self['CFLAGS'] = self['CXXFLAGS'] = "#{cflags * ' '} #{SAFE_CFLAGS}"
  end

  #
  # Tell make not to run the build concurrently.
  #
  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  alias_method :j1, :deparallelize

  #
  # Set the -fast flag.
  # (Though recommended by Apple, wget et. al. won't compile with this flag.)
  #
  def fast
    remove_from_cflags /-O./
    append_to_cflags '-fast'
  end
  
  #
  # Set the -O4 flag (LLVM link-time optimization).
  #
  def O4
    remove_from_cflags /-O./
    append_to_cflags '-O4'
  end
  
  #
  # Set the -O3 flag (-O4 sometimes takes too long).
  #
  def O3
    remove_from_cflags /-O./
    append_to_cflags '-O3'
  end
  
  #
  # Set the -O2 flag (if -O3 doesn't work or produces bad binaries).
  #
  def O2
    remove_from_cflags /-O./
    append_to_cflags '-O2'
  end
  
  #
  # Set the -Os flag (to create small binaries).
  #
  def Os
    remove_from_cflags /-O./
    append_to_cflags '-Os'
  end

  #
  # Set the compiler to gcc-4.0 and use compatible flags.
  #
  def gcc_4_0_1
    self['CC'] = self['LD'] = '/usr/bin/gcc-4.0'
    self['CXX'] = '/usr/bin/g++-4.0'
    self.O3
    remove_from_cflags '-march=core2'
    remove_from_cflags %r{-msse4(\.\d)?}
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  #
  # Set the compiler to gcc-4.2 and use compatible flags.
  #
  def gcc_4_2
    self['CC']="/usr/bin/gcc-4.2"
    self['CXX']="/usr/bin/g++-4.2"
    self['LD']=self['CC']
    self.O3
  end

  #
  # Set the compiler to llvm-gcc and use compatible flags.
  #
  def llvm
    xcode_path = `/usr/bin/xcode-select -print-path`.chomp
    xcode_path = "/Developer" if xcode_path.to_s.empty?
    self['CC'] = "#{xcode_path}/usr/bin/llvm-gcc"
    self['CXX'] = "#{xcode_path}/usr/bin/llvm-g++"
    self['LD'] = self['CC']
    self.O4
  end

  #
  # Enable Tiger-compatibility build options.
  #
  def osx_10_4
    self['MACOSX_DEPLOYMENT_TARGET'] = "10.4"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.4')
  end
  
  #
  # Enable Leopard-compatibility build options.
  #
  def osx_10_5
    self['MACOSX_DEPLOYMENT_TARGET'] = "10.5"
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    append_to_cflags('-mmacosx-version-min=10.5')
  end

  #
  # Optimize this build to reduce binary size only.
  #
  def minimal_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = "-Os #{SAFE_CFLAGS}"
  end
  
  #
  # Do not optimize this build.
  #
  def no_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = SAFE_CFLAGS
  end

  #
  # Tell the preprocessor where to find libxml2.
  #
  def libxml2
    append_to_cflags ' -I/usr/include/libxml2'
  end

  #
  # Tell the compiler to look in /usr/X11R6 for libraries (libpng etc.).
  #
  def x11
    opoo "You do not have X11 installed, this formula may not build." if not x11_installed?

    # There are some config scripts (e.g. freetype) here that should go in the path
    prepend 'PATH', '/usr/X11/bin', ':'
    # CPPFLAGS are the C-PreProcessor flags, *not* C++!
    append 'CPPFLAGS', '-I/usr/X11R6/include'
    append 'LDFLAGS', '-L/usr/X11R6/lib'
    # CMake ignores the variables above
    append 'CMAKE_PREFIX_PATH', '/usr/X11R6', ':'
  end
  alias_method :libpng, :x11

  #
  # Re-enable warnings if required by the package.
  #
  def enable_warnings
    remove_from_cflags '-w'
  end
  
  #
  # Snow Leopard defines an NCURSES value the opposite of most distros.
  #   see: http://bugs.python.org/issue6848)
  # 
  def ncurses_define
    append 'CPPFLAGS', "-DNCURSES_OPAQUE=0"
  end

  #
  # Return the configured C compiler (or `gcc' if undefined).
  #
  def cc
    self['CC'] or "gcc"
  end
  
  #
  # Return the configured CXX compiler (or `g++' if undefined).
  #
  def cxx
    self['CXX'] or "g++"
  end
  
  #
  # Return the CFLAGS for this build.
  #
  def cflags
    self['CFLAGS']
  end
  
  #
  # Return the LDFLAGS for this build.
  #
  def ldflags
    self['LDFLAGS']
  end

  #
  # Generate code for a 64-bit environment.
  #
  def m64
    append_to_cflags '-m64'
    append 'LDFLAGS', '-arch x86_64'
  end
  
  #
  # Generate code for a 32-bit environment.
  #
  def m32
    append_to_cflags '-m32'
    append 'LDFLAGS', '-arch i386'
  end
  
  #
  # Generate code for both 32- and 64-bit environments (but not PPC).
  #
  def universal_binary
    append_to_cflags '-arch i386 -arch x86_64'
    self.O3 if self['CFLAGS'].include? '-O4' # O4 seems to cause the build to fail
    append 'LDFLAGS', '-arch i386 -arch x86_64'

    # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
    remove_from_cflags(/-march=\S*/) if Hardware.is_32_bit?
  end


  #
  # Prepend <tt>value</tt> to <tt>ENV[key]</tt>.
  #
  def prepend key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = value + separator + self[key]
    else
      self[key] = value
    end
  end

  #
  # Append <tt>value<tt> to <tt>ENV[key]</tt>.
  #
  def append key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s
    unless self[key].to_s.empty?
      self[key] = self[key] + separator + value
    else
      self[key] = value
    end
  end

  #
  # Add a specified compiler flag.
  #
  def append_to_cflags f
    append 'CFLAGS', f
    append 'CXXFLAGS', f
  end
  
  #
  # Remove the substring <tt>value</tt> from <tt>ENV[key]</tt>.
  #
  def remove key, value
    return if self[key].nil?
    self[key] = self[key].sub value, '' # can't use sub! on ENV
    self[key] = nil if self[key].empty? # keep things clean
  end
  
  #
  # Remove a specified compiler flag.
  #
  def remove_from_cflags f
    remove 'CFLAGS', f
    remove 'CXXFLAGS', f
  end
end
