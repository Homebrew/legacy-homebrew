require 'hardware'
require 'macos'
require 'extend/ENV/shared'

module Stdenv
  include SharedEnvExtension

  SAFE_CFLAGS_FLAGS = "-w -pipe"
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
      append 'PATH', "#{MacOS.xctoolchain_path}/usr/bin", File::PATH_SEPARATOR if MacOS.xctoolchain_path
      # Others are now at /Applications/Xcode.app/Contents/Developer/usr/bin
      append 'PATH', "#{MacOS.dev_tools_path}", File::PATH_SEPARATOR
    end
  end

  def determine_pkg_config_libdir
    paths = []
    paths << HOMEBREW_PREFIX/'lib/pkgconfig'
    paths << HOMEBREW_PREFIX/'share/pkgconfig'
    paths << HOMEBREW_REPOSITORY/"Library/ENV/pkgconfig/#{MacOS.version}"
    paths << '/usr/lib/pkgconfig'
    paths.select { |d| File.directory? d }.join(File::PATH_SEPARATOR)
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
      append 'CPATH', "#{sdk}/usr/include", File::PATH_SEPARATOR
      # The -isysroot is needed, too, because of the Frameworks
      append_to_cflags "-isysroot #{sdk}"
      append 'CPPFLAGS', "-isysroot #{sdk}"
      # And the linker needs to find sdk/usr/lib
      append 'LDFLAGS', "-isysroot #{sdk}"
      # Needed to build cmake itself and perhaps some cmake projects:
      append 'CMAKE_PREFIX_PATH', "#{sdk}/usr", File::PATH_SEPARATOR
      append 'CMAKE_FRAMEWORK_PATH', "#{sdk}/System/Library/Frameworks", File::PATH_SEPARATOR
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
    append 'PATH', MacOS::X11.bin, File::PATH_SEPARATOR

    # Append these to PKG_CONFIG_LIBDIR so they are searched
    # *after* our own pkgconfig directories, as we dupe some of the
    # libs in XQuartz.
    append 'PKG_CONFIG_LIBDIR', MacOS::X11.lib/'pkgconfig', File::PATH_SEPARATOR
    append 'PKG_CONFIG_LIBDIR', MacOS::X11.share/'pkgconfig', File::PATH_SEPARATOR

    append 'LDFLAGS', "-L#{MacOS::X11.lib}"
    append 'CMAKE_PREFIX_PATH', MacOS::X11.prefix, File::PATH_SEPARATOR
    append 'CMAKE_INCLUDE_PATH', MacOS::X11.include, File::PATH_SEPARATOR

    append 'CPPFLAGS', "-I#{MacOS::X11.include}"

    append 'ACLOCAL_PATH', MacOS::X11.share/'aclocal', File::PATH_SEPARATOR

    unless MacOS::CLT.installed?
      append 'CMAKE_PREFIX_PATH', MacOS.sdk_path/'usr/X11', File::PATH_SEPARATOR
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
