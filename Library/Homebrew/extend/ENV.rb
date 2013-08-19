require 'hardware'
require 'superenv'

def superenv?
  return false if MacOS::Xcode.without_clt? && MacOS.sdk_path.nil?
  return false unless Superenv.bin && Superenv.bin.directory?
  return false if ARGV.include? "--env=std"
  true
end

module EnvActivation
  def activate_extensions!
    if superenv?
      extend(Superenv)
    else
      extend(HomebrewEnvExtension)
    end
  end
end

ENV.extend(EnvActivation)

module HomebrewEnvExtension
  SAFE_CFLAGS_FLAGS = "-w -pipe"
  CC_FLAG_VARS = %w{CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS}
  FC_FLAG_VARS = %w{FCFLAGS FFLAGS}
  DEFAULT_FLAGS = '-march=core2 -msse4'

  def self.extended(base)
    unless ORIGINAL_PATHS.include? HOMEBREW_PREFIX/'bin'
      base.prepend_path 'PATH', "#{HOMEBREW_PREFIX}/bin"
    end
  end

  def setup_build_environment
    # Clear CDPATH to avoid make issues that depend on changing directories
    delete('CDPATH')
    delete('GREP_OPTIONS') # can break CMake (lol)
    delete('CLICOLOR_FORCE') # autotools doesn't like this
    %w{CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH}.each { |k| delete(k) }
    remove_cc_etc

    if MacOS.version >= :mountain_lion
      # Mountain Lion's sed is stricter, and errors out when
      # it encounters files with mixed character sets
      delete('LC_ALL')
      self['LC_CTYPE']="C"
    end

    # Set the default pkg-config search path, overriding the built-in paths
    # Anything in PKG_CONFIG_PATH is searched before paths in this variable
    self['PKG_CONFIG_LIBDIR'] = determine_pkg_config_libdir

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

    if (HOMEBREW_PREFIX/'Frameworks').exist?
      append 'CPPFLAGS', "-F#{HOMEBREW_PREFIX}/Frameworks"
      append 'LDFLAGS', "-F#{HOMEBREW_PREFIX}/Frameworks"
      self['CMAKE_FRAMEWORK_PATH'] = HOMEBREW_PREFIX/"Frameworks"
    end

    # Os is the default Apple uses for all its stuff so let's trust them
    set_cflags "-Os #{SAFE_CFLAGS_FLAGS}"

    # set us up for the user's compiler choice
    self.send self.compiler

    # we must have a working compiler!
    unless self['CC']
      @compiler = MacOS.default_compiler
      self.send @compiler
      self['CC'] = self['OBJC'] = MacOS.locate("cc")
      self['CXX'] = self['OBJCXX'] = MacOS.locate("c++")
    end

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

  def determine_pkg_config_libdir
    paths = []
    paths << HOMEBREW_PREFIX/'lib/pkgconfig'
    paths << HOMEBREW_PREFIX/'share/pkgconfig'
    paths << HOMEBREW_REPOSITORY/"Library/ENV/pkgconfig/#{MacOS.version}"
    paths << '/usr/lib/pkgconfig'
    paths.select { |d| File.directory? d }.join(':')
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
    self['CC'] = self['OBJC'] = "#{MacOS.dev_tools_path}/gcc-4.0"
    self['CXX'] = self['OBJCXX'] = "#{MacOS.dev_tools_path}/g++-4.0"
    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags '-march=nocona -mssse3'
    @compiler = :gcc
  end
  alias_method :gcc_4_0, :gcc_4_0_1

  # if your formula doesn't like CC having spaces use this
  def expand_xcrun
    self['CC'] =~ %r{/usr/bin/xcrun (.*)}
    self['CC'] = `/usr/bin/xcrun -find #{$1}`.chomp if $1
    self['CXX'] =~ %r{/usr/bin/xcrun (.*)}
    self['CXX'] = `/usr/bin/xcrun -find #{$1}`.chomp if $1
    self['OBJC'] = self['CC']
    self['OBJCXX'] = self['CXX']
  end

  def gcc
    # Apple stopped shipping gcc-4.2 with Xcode 4.2
    # However they still provide a gcc symlink to llvm
    # But we don't want LLVM of course.

    self['CC'] = self['OBJC'] = MacOS.locate("gcc-4.2")
    self['CXX'] = self['OBJCXX'] = MacOS.locate("g++-4.2")

    unless self['CC']
      self['CC'] = self['OBJC'] = "#{HOMEBREW_PREFIX}/bin/gcc-4.2"
      self['CXX'] = self['OBJCXX'] = "#{HOMEBREW_PREFIX}/bin/g++-4.2"
      raise "GCC could not be found" unless File.exist? self['CC']
    end

    if not self['CC'] =~ %r{^/usr/bin/xcrun }
      raise "GCC could not be found" if Pathname.new(self['CC']).realpath.to_s =~ /llvm/
    end

    replace_in_cflags '-O4', '-O3'
    set_cpu_cflags
    @compiler = :gcc
  end
  alias_method :gcc_4_2, :gcc

  def llvm
    self['CC'] = self['OBJC'] = MacOS.locate("llvm-gcc")
    self['CXX'] = self['OBJCXX'] = MacOS.locate("llvm-g++")
    set_cpu_cflags
    @compiler = :llvm
  end

  def clang
    self['CC'] = self['OBJC'] = MacOS.locate("clang")
    self['CXX'] = self['OBJCXX'] = MacOS.locate("clang++")
    replace_in_cflags(/-Xarch_#{Hardware::CPU.arch_32_bit} (-march=\S*)/, '\1')
    # Clang mistakenly enables AES-NI on plain Nehalem
    set_cpu_cflags '-march=native', :nehalem => '-march=native -Xclang -target-feature -Xclang -aes'
    append_to_cflags '-Qunused-arguments'
    @compiler = :clang
  end

  def remove_macosxsdk version=MacOS.version
    # Clear all lib and include dirs from CFLAGS, CPPFLAGS, LDFLAGS that were
    # previously added by macosxsdk
    version = version.to_s
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    delete('MACOSX_DEPLOYMENT_TARGET')
    delete('CPATH')
    remove 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if (sdk = MacOS.sdk_path(version)) && !MacOS::CLT.installed?
      delete('SDKROOT')
      remove_from_cflags "-isysroot #{sdk}"
      remove 'CPPFLAGS', "-isysroot #{sdk}"
      remove 'LDFLAGS', "-isysroot #{sdk}"
      if HOMEBREW_PREFIX.to_s == '/usr/local'
        delete('CMAKE_PREFIX_PATH')
      else
        # It was set in setup_build_environment, so we have to restore it here.
        self['CMAKE_PREFIX_PATH'] = "#{HOMEBREW_PREFIX}"
      end
      remove 'CMAKE_FRAMEWORK_PATH', "#{sdk}/System/Library/Frameworks"
    end
  end

  def macosxsdk version=MacOS.version
    return unless MACOS
    # Sets all needed lib and include dirs to CFLAGS, CPPFLAGS, LDFLAGS.
    remove_macosxsdk
    version = version.to_s
    append_to_cflags("-mmacosx-version-min=#{version}")
    self['MACOSX_DEPLOYMENT_TARGET'] = version
    self['CPATH'] = "#{HOMEBREW_PREFIX}/include"
    prepend 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if (sdk = MacOS.sdk_path(version)) && !MacOS::CLT.installed?
      # Extra setup to support Xcode 4.3+ without CLT.
      self['SDKROOT'] = sdk
      # Tell clang/gcc where system include's are:
      append 'CPATH', "#{sdk}/usr/include", ":"
      # The -isysroot is needed, too, because of the Frameworks
      append_to_cflags "-isysroot #{sdk}"
      append 'CPPFLAGS', "-isysroot #{sdk}"
      # And the linker needs to find sdk/usr/lib
      append 'LDFLAGS', "-isysroot #{sdk}"
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
    # There are some config scripts here that should go in the PATH
    append 'PATH', MacOS::X11.bin, ':'

    # Append these to PKG_CONFIG_LIBDIR so they are searched
    # *after* our own pkgconfig directories, as we dupe some of the
    # libs in XQuartz.
    append 'PKG_CONFIG_LIBDIR', MacOS::X11.lib/'pkgconfig', ':'
    append 'PKG_CONFIG_LIBDIR', MacOS::X11.share/'pkgconfig', ':'

    append 'LDFLAGS', "-L#{MacOS::X11.lib}"
    append 'CMAKE_PREFIX_PATH', MacOS::X11.prefix, ':'
    append 'CMAKE_INCLUDE_PATH', MacOS::X11.include, ':'

    append 'CPPFLAGS', "-I#{MacOS::X11.include}"

    append 'ACLOCAL_PATH', MacOS::X11.share/'aclocal', ':'

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

  def m64
    append_to_cflags '-m64'
    append 'LDFLAGS', "-arch #{Hardware::CPU.arch_64_bit}"
  end
  def m32
    append_to_cflags '-m32'
    append 'LDFLAGS', "-arch #{Hardware::CPU.arch_32_bit}"
  end

  def universal_binary
    append_to_cflags Hardware::CPU.universal_archs.as_arch_flags
    replace_in_cflags '-O4', '-O3' # O4 seems to cause the build to fail
    append 'LDFLAGS', Hardware::CPU.universal_archs.as_arch_flags

    if compiler != :clang && Hardware.is_32_bit?
      # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
      replace_in_cflags(/-march=\S*/, "-Xarch_#{Hardware::CPU.arch_32_bit} \\0")
    end
  end

  def replace_in_cflags before, after
    CC_FLAG_VARS.each do |key|
      self[key] = self[key].sub(before, after) if has_key?(key)
    end
  end

  # Convenience method to set all C compiler flags in one shot.
  def set_cflags val
    CC_FLAG_VARS.each { |key| self[key] = val }
  end

  # Sets architecture-specific flags for every environment variable
  # given in the list `flags`.
  def set_cpu_flags flags, default=DEFAULT_FLAGS, map=Hardware::CPU.optimization_flags
    cflags =~ %r{(-Xarch_#{Hardware::CPU.arch_32_bit} )-march=}
    xarch = $1.to_s
    remove flags, %r{(-Xarch_#{Hardware::CPU.arch_32_bit} )?-march=\S*}
    remove flags, %r{( -Xclang \S+)+}
    remove flags, %r{-mssse3}
    remove flags, %r{-msse4(\.\d)?}
    append flags, xarch unless xarch.empty?

    if ARGV.build_bottle?
      append flags, Hardware::CPU.optimization_flags[Hardware.oldest_cpu]
    else
      # Don't set -msse3 and older flags because -march does that for us
      append flags, map.fetch(Hardware::CPU.family, default)
    end

    # not really a 'CPU' cflag, but is only used with clang
    remove flags, '-Qunused-arguments'
  end

  def set_cpu_cflags default=DEFAULT_FLAGS, map=Hardware::CPU.optimization_flags
    set_cpu_flags CC_FLAG_VARS, default, map
  end

  # actually c-compiler, so cc would be a better name
  def compiler
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
      Hardware::CPU.cores
    end
  end

  # ld64 is a newer linker provided for Xcode 2.5
  def ld64
    ld64 = Formula.factory('ld64')
    self['LD'] = ld64.bin/'ld'
    append "LDFLAGS", "-B#{ld64.bin.to_s+"/"}"
  end
end

class << ENV
  def remove_cc_etc
    keys = %w{CC CXX OBJC OBJCXX LD CPP CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS}
    removed = Hash[*keys.map{ |key| [key, self[key]] }.flatten]
    keys.each do |key|
      delete(key)
    end
    removed
  end
  def append_to_cflags newflags
    append(HomebrewEnvExtension::CC_FLAG_VARS, newflags)
  end
  def remove_from_cflags val
    remove HomebrewEnvExtension::CC_FLAG_VARS, val
  end
  def append keys, value, separator = ' '
    value = value.to_s
    Array(keys).each do |key|
      unless self[key].to_s.empty?
        self[key] = self[key] + separator + value.to_s
      else
        self[key] = value.to_s
      end
    end
  end
  def prepend keys, value, separator = ' '
    Array(keys).each do |key|
      unless self[key].to_s.empty?
        self[key] = value.to_s + separator + self[key]
      else
        self[key] = value.to_s
      end
    end
  end
  def prepend_path key, path
    prepend key, path, ':' if File.directory? path
  end
  def remove keys, value
    Array(keys).each do |key|
      next unless self[key]
      self[key] = self[key].sub(value, '')
      delete(key) if self[key].to_s.empty?
    end if value
  end

  def cc;       self['CC'] or "cc";   end
  def cxx;      self['CXX'] or "c++"; end
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
    self['PATH'] = paths.unshift(*self['PATH'].split(":")).uniq.join(":")
    # XXX hot fix to prefer brewed stuff (e.g. python) over /usr/bin.
    prepend 'PATH', HOMEBREW_PREFIX/'bin', ':'
  end

  def with_build_environment
    old_env = to_hash
    setup_build_environment
    yield
  ensure
    replace(old_env)
  end

  def fortran
    # superenv removes these PATHs, but this option needs them
    # TODO fix better, probably by making a super-fc
    ENV['PATH'] += ":#{HOMEBREW_PREFIX}/bin:/usr/local/bin"

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

      HomebrewEnvExtension::FC_FLAG_VARS.each {|key| self[key] = cflags}
      set_cpu_flags(HomebrewEnvExtension::FC_FLAG_VARS)
    end
  end
end
