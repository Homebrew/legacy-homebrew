module HomebrewEnvExtension
  # -w: keep signal to noise high
  SAFE_CFLAGS_FLAGS = "-w -pipe"

  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    delete('CDPATH')
    delete('GREP_OPTIONS') # can break CMake (lol)
    delete('CLICOLOR_FORCE') # autotools doesn't like this
    remove_cc_etc

    if MacOS.version >= :mountain_lion
      # Fix issue with sed barfing on unicode characters on Mountain Lion.
      delete('LC_ALL')
      self['LC_CTYPE']="C"

      # Mountain Lion no longer ships a few .pcs; make sure we pick up our versions
      prepend 'PKG_CONFIG_PATH',
        HOMEBREW_REPOSITORY/'Library/Homebrew/pkgconfig', ':'
    end

    # make any aclocal stuff installed in Homebrew available
    self['ACLOCAL_PATH'] = "#{HOMEBREW_PREFIX}/share/aclocal" if MacOS::Xcode.provides_autotools?

    self['MAKEFLAGS'] = "-j#{self.make_jobs}"

    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      # /usr/local is already an -isystem and -L directory so we skip it
      self['CPPFLAGS'] = "-isystem #{HOMEBREW_PREFIX}/include"
      self['LDFLAGS'] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
    end

    # Os is the default Apple uses for all its stuff so let's trust them
    set_cflags "-Os #{SAFE_CFLAGS_FLAGS}"

    # set us up for the user's compiler choice
    self.send self.compiler

    # we must have a working compiler!
    unless self['CC']
      @compiler = MacOS.default_compiler
      self.send @compiler
      self['CC'] = MacOS.locate("cc")
      self['CXX'] = MacOS.locate("c++")
      self['OBJC'] = self['CC']
    end

    # In rare cases this may break your builds, as the tool for some reason wants
    # to use a specific linker. However doing this in general causes formula to
    # build more successfully because we are changing CC and many build systems
    # don't react properly to that.
    self['LD'] = self['CC']

    # Add lib and include etc. from the current macosxsdk to compiler flags:
    macosxsdk MacOS.version

    # For Xcode 4.3 (*without* the "Command Line Tools for Xcode") compiler and tools inside of Xcode:
    if not MacOS::CLT.installed? and MacOS::Xcode.installed? and MacOS::Xcode.version >= "4.3"
      # Some tools (clang, etc.) are in the xctoolchain dir of Xcode
      append 'PATH', "#{MacOS.xctoolchain_path}/usr/bin", ":" if MacOS.xctoolchain_path
      # Others are now at /Applications/Xcode.app/Contents/Developer/usr/bin
      append 'PATH', "#{MacOS.dev_tools_path}", ":"
    end
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
  def O1
    # Sometimes even O2 doesn't work :(
    remove_from_cflags(/-O./)
    append_to_cflags '-O1'
  end

  def gcc_4_0_1
    # we don't use locate because gcc 4.0 has not been provided since Xcode 4
    self['CC'] = "#{MacOS.dev_tools_path}/gcc-4.0"
    self['LD'] = self['CC']
    self['CXX'] = "#{MacOS.dev_tools_path}/g++-4.0"
    self['OBJC'] = self['CC']
    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags 'nocona -mssse3', :core => 'prescott', :bottle => 'generic'
    @compiler = :gcc
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  # if your formula doesn't like CC having spaces use this
  def expand_xcrun
    self['CC'] =~ %r{/usr/bin/xcrun (.*)}
    self['CC'] = `/usr/bin/xcrun -find #{$1}`.chomp if $1
    self['CXX'] =~ %r{/usr/bin/xcrun (.*)}
    self['CXX'] = `/usr/bin/xcrun -find #{$1}`.chomp if $1
    self['LD'] = self['CC']
    self['OBJC'] = self['CC']
  end

  def gcc
    # Apple stopped shipping gcc-4.2 with Xcode 4.2
    # However they still provide a gcc symlink to llvm
    # But we don't want LLVM of course.

    self['CC'] = MacOS.locate "gcc-4.2"
    self['LD'] = self['CC']
    self['CXX'] = MacOS.locate "g++-4.2"
    self['OBJC'] = self['CC']

    unless self['CC']
      self['CC'] = "#{HOMEBREW_PREFIX}/bin/gcc-4.2"
      self['LD'] = self['CC']
      self['CXX'] = "#{HOMEBREW_PREFIX}/bin/g++-4.2"
      self['OBJC'] = self['CC']
      raise "GCC could not be found" unless File.exist? self['CC']
    end

    if not self['CC'] =~ %r{^/usr/bin/xcrun }
      raise "GCC could not be found" if Pathname.new(self['CC']).realpath.to_s =~ /llvm/
    end

    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott', :bottle => 'generic'
    @compiler = :gcc
  end
  alias_method :gcc_4_2, :gcc

  def llvm
    self['CC'] = MacOS.locate "llvm-gcc"
    self['LD'] = self['CC']
    self['CXX'] = MacOS.locate "llvm-g++"
    self['OBJC'] = self['CC']
    set_cpu_cflags 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott'
    @compiler = :llvm
  end

  def clang
    self['CC'] = MacOS.locate "clang"
    self['LD'] = self['CC']
    self['CXX'] = MacOS.locate "clang++"
    self['OBJC'] = self['CC']
    replace_in_cflags(/-Xarch_i386 (-march=\S*)/, '\1')
    # Clang mistakenly enables AES-NI on plain Nehalem
    set_cpu_cflags 'native', :nehalem => 'native -Xclang -target-feature -Xclang -aes'
    append_to_cflags '-Qunused-arguments'
    @compiler = :clang
  end

  def fortran
    if self['FC']
      ohai "Building with an alternative Fortran compiler. This is unsupported."
      self['F77'] = self['FC'] unless self['F77']

      if ARGV.include? '--default-fortran-flags'
        flags_to_set = []
        flags_to_set << 'FCFLAGS' unless self['FCFLAGS']
        flags_to_set << 'FFLAGS' unless self['FFLAGS']

        flags_to_set.each {|key| self[key] = cflags}

        # Ensure we use architecture optimizations for GCC 4.2.x
        set_cpu_flags flags_to_set, 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott', :bottle => 'generic'
      elsif not self['FCFLAGS'] or self['FFLAGS']
        opoo <<-EOS.undent
          No Fortran optimization information was provided.  You may want to consider
          setting FCFLAGS and FFLAGS or pass the `--default-fortran-flags` option to
          `brew install` if your compiler is compatible with GCC.

          If you like the default optimization level of your compiler, ignore this
          warning.
        EOS
      end

    elsif `/usr/bin/which gfortran`.chomp.size > 0
      ohai <<-EOS.undent
        Using Homebrew-provided fortran compiler.
        This may be changed by setting the FC environment variable.
        EOS
      self['FC'] = `/usr/bin/which gfortran`.chomp
      self['F77'] = self['FC']

      fc_flag_vars.each {|key| self[key] = cflags}
      # Ensure we use architecture optimizations for GCC 4.2.x
      set_cpu_flags fc_flag_vars, 'core2 -msse4', :penryn => 'core2 -msse4.1', :core2 => 'core2', :core => 'prescott', :bottle => 'generic'

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

  def remove_macosxsdk v=MacOS.version
    # Clear all lib and include dirs from CFLAGS, CPPFLAGS, LDFLAGS that were
    # previously added by macosxsdk
    v = v.to_s
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    self['MACOSX_DEPLOYMENT_TARGET'] = nil
    remove 'CPPFLAGS', "-isystem #{HOMEBREW_PREFIX}/include"
    remove 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    sdk = MacOS.sdk_path(v)
    unless sdk.nil? or MacOS::CLT.installed?
      self['SDKROOT'] = nil
      remove 'CPPFLAGS', "-isysroot #{sdk}"
      remove 'CPPFLAGS', "-isystem #{sdk}/usr/include"
      remove 'CPPFLAGS', "-I#{sdk}/usr/include"
      remove_from_cflags "-isystem #{sdk}/usr/include"
      remove_from_cflags "-isysroot #{sdk}"
      remove_from_cflags "-I#{sdk}/usr/include"
      remove 'LDFLAGS', "-L#{sdk}/usr/lib"
      remove 'LDFLAGS', "-I#{sdk}/usr/include"
      if HOMEBREW_PREFIX.to_s == '/usr/local'
        self['CMAKE_PREFIX_PATH'] = nil
      else
        # It was set in setup_build_environment, so we have to restore it here.
        self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
      end
      remove 'CMAKE_FRAMEWORK_PATH', "#{sdk}/System/Library/Frameworks"
    end
  end

  def macosxsdk v=MacOS.version
    # Sets all needed lib and include dirs to CFLAGS, CPPFLAGS, LDFLAGS.
    remove_macosxsdk
    # Allow cool style of ENV.macosxsdk 10.8 here (no "" :)
    v = v.to_s
    append_to_cflags("-mmacosx-version-min=#{v}")
    self['MACOSX_DEPLOYMENT_TARGET'] = v
    append 'CPPFLAGS', "-isystem #{HOMEBREW_PREFIX}/include"
    prepend 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    sdk = MacOS.sdk_path(v)
    unless sdk.nil? or MacOS::CLT.installed?
      # Extra setup to support Xcode 4.3+ without CLT.
      self['SDKROOT'] = sdk
      # Teach the preprocessor and compiler (some don't respect CPPFLAGS)
      # where system includes are:
      append 'CPPFLAGS', "-isysroot #{sdk}"
      append_to_cflags "-isysroot #{sdk}"
      append 'CPPFLAGS', "-isystem #{sdk}/usr/include"
      # Suggested by mxcl (https://github.com/mxcl/homebrew/pull/10510#issuecomment-4187996):
      append_to_cflags "-isystem #{sdk}/usr/include"
      # Some software needs this (e.g. python shows error: /usr/include/zlib.h: No such file or directory)
      append 'CPPFLAGS', "-I#{sdk}/usr/include"
      # And finally the "normal" things one expects for the CFLAGS and LDFLAGS:
      append_to_cflags "-I#{sdk}/usr/include"
      append 'LDFLAGS', "-L#{sdk}/usr/lib"
      # Believe it or not, sometimes only the LDFLAGS are used :/
      append 'LDFLAGS', "-I#{sdk}/usr/include"
      # Needed to build cmake itself and perhaps some cmake projects:
      append 'CMAKE_PREFIX_PATH', "#{sdk}/usr", ':'
      append 'CMAKE_FRAMEWORK_PATH', "#{sdk}/System/Library/Frameworks", ':'
    end
  end

  def minimal_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = "-Os #{SAFE_CFLAGS_FLAGS}"
    macosxsdk unless MacOS::CLT.installed?
  end
  def no_optimization
    self['CFLAGS'] = self['CXXFLAGS'] = SAFE_CFLAGS_FLAGS
    macosxsdk unless MacOS::CLT.installed?
  end

  # Some configure scripts won't find libxml2 without help
  def libxml2
    if MacOS::CLT.installed?
      append 'CPPFLAGS', '-I/usr/include/libxml2'
    else
      # Use the includes form the sdk
      append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/libxml2"
    end
  end

  def x11
    unless MacOS::X11.installed?
      opoo "You do not have X11 installed, this formula may not build."
    end

    # There are some config scripts here that should go in the PATH
    prepend 'PATH', MacOS::X11.bin, ':'

    prepend 'PKG_CONFIG_PATH', MacOS::X11.lib/'pkgconfig', ':'
    prepend 'PKG_CONFIG_PATH', MacOS::X11.share/'pkgconfig', ':'

    append 'LDFLAGS', "-L#{MacOS::X11.lib}"
    append 'CMAKE_PREFIX_PATH', MacOS::X11.prefix, ':'
    append 'CMAKE_INCLUDE_PATH', MacOS::X11.include, ':'

    append 'CPPFLAGS', "-I#{MacOS::X11.include}"

    unless MacOS::CLT.installed?
      append 'CMAKE_PREFIX_PATH', MacOS.sdk_path/'usr/X11', ':'
      append 'CPPFLAGS', "-I#{MacOS::X11.include}/freetype2"
      append 'CFLAGS', "-I#{MacOS::X11.include}"
    end
  end
  alias_method :libpng, :x11

  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags '-w'
    remove_from_cflags '-Qunused-arguments'
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
  def cxxflags;self['CXXFLAGS'];     end
  def cppflags;self['CPPFLAGS'];     end
  def ldflags; self['LDFLAGS'];      end

  # Shortcuts for lists of common flags
  def cc_flag_vars
    %w{CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS}
  end
  def fc_flag_vars
    %w{FCFLAGS FFLAGS}
  end

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
    replace_in_cflags '-O4', '-O3' # O4 seems to cause the build to fail
    append 'LDFLAGS', '-arch i386 -arch x86_64'

    unless compiler == :clang
      # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
      replace_in_cflags(/-march=\S*/, '-Xarch_i386 \0') if Hardware.is_32_bit?
    end
  end

  def prepend key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s

    [*key].each do |key|
      unless self[key].to_s.empty?
        self[key] = value + separator + self[key]
      else
        self[key] = value
      end
    end
  end

  def append key, value, separator = ' '
    # Value should be a string, but if it is a pathname then coerce it.
    value = value.to_s

    [*key].each do |key|
      unless self[key].to_s.empty?
        self[key] = self[key] + separator + value
      else
        self[key] = value
      end
    end
  end

  def append_to_cflags f
    append cc_flag_vars, f
  end

  def remove key, value
    [*key].each do |key|
      next if self[key].nil?
      self[key] = self[key].sub value, '' # can't use sub! on ENV
      self[key] = nil if self[key].empty? # keep things clean
    end
  end

  def remove_from_cflags f
    remove cc_flag_vars, f
  end

  def replace_in_cflags before, after
    cc_flag_vars.each do |key|
      self[key] = self[key].sub before, after if self[key]
    end
  end

  # Convenience method to set all C compiler flags in one shot.
  def set_cflags f
    cc_flag_vars.each do |key|
      self[key] = f
    end
  end

  # Sets architecture-specific flags for every environment variable
  # given in the list `flags`.
  def set_cpu_flags flags, default, map = {}
    cflags =~ %r{(-Xarch_i386 )-march=}
    xarch = $1.to_s
    remove flags, %r{(-Xarch_i386 )?-march=\S*}
    remove flags, %r{( -Xclang \S+)+}
    remove flags, %r{-mssse3}
    remove flags, %r{-msse4(\.\d)?}
    append flags, xarch unless xarch.empty?

    if ARGV.build_bottle?
      append flags, '-mtune=' + map.fetch(:bottle) if map.has_key? :bottle
    else
      # Don't set -msse3 and older flags because -march does that for us
      append flags, '-march=' + map.fetch(Hardware.intel_family, default)
    end

    # not really a 'CPU' cflag, but is only used with clang
    remove flags, '-Qunused-arguments'
  end

  def set_cpu_cflags default, map = {}
    set_cpu_flags cc_flag_vars, default, map
  end

  # actually c-compiler, so cc would be a better name
  def compiler
    # TODO seems that ENV.clang in a Formula.install should warn when called
    # if the user has set something that is tested here

    # test for --flags first so that installs can be overridden on a per
    # install basis. Then test for ENVs in inverse order to flags, this is
    # sensible, trust me
    @compiler ||= if ARGV.include? '--use-gcc'
      :gcc
    elsif ARGV.include? '--use-llvm'
      :llvm
    elsif ARGV.include? '--use-clang'
      :clang
    elsif self['HOMEBREW_USE_CLANG']
      :clang
    elsif self['HOMEBREW_USE_LLVM']
      :llvm
    elsif self['HOMEBREW_USE_GCC']
      :gcc
    else
      MacOS.default_compiler
    end
  end

  def make_jobs
    # '-j' requires a positive integral argument
    if self['HOMEBREW_MAKE_JOBS'].to_i > 0
      self['HOMEBREW_MAKE_JOBS'].to_i
    else
      Hardware.processor_count
    end
  end

  def remove_cc_etc
    keys = %w{CC CXX LD CPP CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS}
    removed = Hash[*keys.map{ |key| [key, self[key]] }.flatten]
    keys.each do |key|
      self[key] = nil
    end
    removed
  end
end
