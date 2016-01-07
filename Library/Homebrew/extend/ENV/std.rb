require "hardware"
require "extend/ENV/shared"

# TODO: deprecate compiling related codes after it's only used by brew test.
# @private
module Stdenv
  include SharedEnvExtension

  # @private
  SAFE_CFLAGS_FLAGS = "-w -pipe"
  DEFAULT_FLAGS = "-march=core2 -msse4"

  def self.extended(base)
    unless ORIGINAL_PATHS.include? HOMEBREW_PREFIX/"bin"
      base.prepend_path "PATH", "#{HOMEBREW_PREFIX}/bin"
    end
  end

  # @private
  def setup_build_environment(formula = nil)
    super

    if MacOS.version >= :mountain_lion
      # Mountain Lion's sed is stricter, and errors out when
      # it encounters files with mixed character sets
      delete("LC_ALL")
      self["LC_CTYPE"]="C"
    end

    # Set the default pkg-config search path, overriding the built-in paths
    # Anything in PKG_CONFIG_PATH is searched before paths in this variable
    self["PKG_CONFIG_LIBDIR"] = determine_pkg_config_libdir

    # make any aclocal stuff installed in Homebrew available
    self["ACLOCAL_PATH"] = "#{HOMEBREW_PREFIX}/share/aclocal" if MacOS.has_apple_developer_tools? && MacOS::Xcode.provides_autotools?

    self["MAKEFLAGS"] = "-j#{make_jobs}"

    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      # /usr/local is already an -isystem and -L directory so we skip it
      self["CPPFLAGS"] = "-isystem#{HOMEBREW_PREFIX}/include"
      self["LDFLAGS"] = "-L#{HOMEBREW_PREFIX}/lib"
      # CMake ignores the variables above
      self["CMAKE_PREFIX_PATH"] = HOMEBREW_PREFIX.to_s
    end

    frameworks = HOMEBREW_PREFIX.join("Frameworks")
    if frameworks.directory?
      append "CPPFLAGS", "-F#{frameworks}"
      append "LDFLAGS", "-F#{frameworks}"
      self["CMAKE_FRAMEWORK_PATH"] = frameworks.to_s
    end

    # Os is the default Apple uses for all its stuff so let's trust them
    set_cflags "-Os #{SAFE_CFLAGS_FLAGS}"

    append "LDFLAGS", "-Wl,-headerpad_max_install_names"

    send(compiler)

    if cc =~ GNU_GCC_REGEXP
      gcc_formula = gcc_version_formula($&)
      append_path "PATH", gcc_formula.opt_bin.to_s
    end

    # Add lib and include etc. from the current macosxsdk to compiler flags:
    macosxsdk MacOS.version

    if MacOS::Xcode.without_clt?
      append_path "PATH", "#{MacOS::Xcode.prefix}/usr/bin"
      append_path "PATH", "#{MacOS::Xcode.toolchain_path}/usr/bin"
    end
  end

  # @private
  def determine_pkg_config_libdir
    paths = []
    paths << "#{HOMEBREW_PREFIX}/lib/pkgconfig"
    paths << "#{HOMEBREW_PREFIX}/share/pkgconfig"
    paths << "#{HOMEBREW_LIBRARY}/ENV/pkgconfig/#{MacOS.version}"
    paths << "/usr/lib/pkgconfig"
    paths.select { |d| File.directory? d }.join(File::PATH_SEPARATOR)
  end

  # Removes the MAKEFLAGS environment variable, causing make to use a single job.
  # This is useful for makefiles with race conditions.
  # When passed a block, MAKEFLAGS is removed only for the duration of the block and is restored after its completion.
  def deparallelize
    old = self["MAKEFLAGS"]
    remove "MAKEFLAGS", /-j\d+/
    if block_given?
      begin
        yield
      ensure
        self["MAKEFLAGS"] = old
      end
    end

    old
  end
  alias_method :j1, :deparallelize

  # These methods are no-ops for compatibility.
  %w[fast O4 Og].each { |opt| define_method(opt) {} }

  %w[O3 O2 O1 O0 Os].each do |opt|
    define_method opt do
      remove_from_cflags(/-O./)
      append_to_cflags "-#{opt}"
    end
  end

  # @private
  def determine_cc
    s = super
    MacOS.locate(s) || Pathname.new(s)
  end

  # @private
  def determine_cxx
    dir, base = determine_cc.split
    dir / base.to_s.sub("gcc", "g++").sub("clang", "clang++")
  end

  def gcc_4_0
    super
    set_cpu_cflags "-march=nocona -mssse3"
  end
  alias_method :gcc_4_0_1, :gcc_4_0

  def gcc
    super
    set_cpu_cflags
  end
  alias_method :gcc_4_2, :gcc

  GNU_GCC_VERSIONS.each do |n|
    define_method(:"gcc-#{n}") do
      super()
      set_cpu_cflags
    end
  end

  def llvm
    super
    set_cpu_cflags
  end

  def clang
    super
    replace_in_cflags(/-Xarch_#{Hardware::CPU.arch_32_bit} (-march=\S*)/, '\1')
    # Clang mistakenly enables AES-NI on plain Nehalem
    map = Hardware::CPU.optimization_flags
    map = map.merge(:nehalem => "-march=native -Xclang -target-feature -Xclang -aes")
    set_cpu_cflags "-march=native", map
  end

  def remove_macosxsdk(version = MacOS.version)
    # Clear all lib and include dirs from CFLAGS, CPPFLAGS, LDFLAGS that were
    # previously added by macosxsdk
    version = version.to_s
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
    delete("MACOSX_DEPLOYMENT_TARGET")
    delete("CPATH")
    remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    if (sdk = MacOS.sdk_path(version)) && !MacOS::CLT.installed?
      delete("SDKROOT")
      remove_from_cflags "-isysroot #{sdk}"
      remove "CPPFLAGS", "-isysroot #{sdk}"
      remove "LDFLAGS", "-isysroot #{sdk}"
      if HOMEBREW_PREFIX.to_s == "/usr/local"
        delete("CMAKE_PREFIX_PATH")
      else
        # It was set in setup_build_environment, so we have to restore it here.
        self["CMAKE_PREFIX_PATH"] = HOMEBREW_PREFIX.to_s
      end
      remove "CMAKE_FRAMEWORK_PATH", "#{sdk}/System/Library/Frameworks"
    end
  end

  def macosxsdk(version = MacOS.version)
    return unless OS.mac?
    # Sets all needed lib and include dirs to CFLAGS, CPPFLAGS, LDFLAGS.
    remove_macosxsdk
    version = version.to_s
    append_to_cflags("-mmacosx-version-min=#{version}")
    self["MACOSX_DEPLOYMENT_TARGET"] = version
    self["CPATH"] = "#{HOMEBREW_PREFIX}/include"
    prepend "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    if (sdk = MacOS.sdk_path(version)) && !MacOS::CLT.installed?
      # Extra setup to support Xcode 4.3+ without CLT.
      self["SDKROOT"] = sdk
      # Tell clang/gcc where system include's are:
      append_path "CPATH", "#{sdk}/usr/include"
      # The -isysroot is needed, too, because of the Frameworks
      append_to_cflags "-isysroot #{sdk}"
      append "CPPFLAGS", "-isysroot #{sdk}"
      # And the linker needs to find sdk/usr/lib
      append "LDFLAGS", "-isysroot #{sdk}"
      # Needed to build cmake itself and perhaps some cmake projects:
      append_path "CMAKE_PREFIX_PATH", "#{sdk}/usr"
      append_path "CMAKE_FRAMEWORK_PATH", "#{sdk}/System/Library/Frameworks"
    end
  end

  def minimal_optimization
    set_cflags "-Os #{SAFE_CFLAGS_FLAGS}"
    macosxsdk unless MacOS::CLT.installed?
  end

  def no_optimization
    set_cflags SAFE_CFLAGS_FLAGS
    macosxsdk unless MacOS::CLT.installed?
  end

  # Some configure scripts won't find libxml2 without help
  def libxml2
    if MacOS::CLT.installed?
      append "CPPFLAGS", "-I/usr/include/libxml2"
    else
      # Use the includes form the sdk
      append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/libxml2"
    end
  end

  def x11
    # There are some config scripts here that should go in the PATH
    append_path "PATH", MacOS::X11.bin.to_s

    # Append these to PKG_CONFIG_LIBDIR so they are searched
    # *after* our own pkgconfig directories, as we dupe some of the
    # libs in XQuartz.
    append_path "PKG_CONFIG_LIBDIR", "#{MacOS::X11.lib}/pkgconfig"
    append_path "PKG_CONFIG_LIBDIR", "#{MacOS::X11.share}/pkgconfig"

    append "LDFLAGS", "-L#{MacOS::X11.lib}"
    append_path "CMAKE_PREFIX_PATH", MacOS::X11.prefix.to_s
    append_path "CMAKE_INCLUDE_PATH", MacOS::X11.include.to_s
    append_path "CMAKE_INCLUDE_PATH", "#{MacOS::X11.include}/freetype2"

    append "CPPFLAGS", "-I#{MacOS::X11.include}"
    append "CPPFLAGS", "-I#{MacOS::X11.include}/freetype2"

    append_path "ACLOCAL_PATH", "#{MacOS::X11.share}/aclocal"

    if MacOS::XQuartz.provided_by_apple? && !MacOS::CLT.installed?
      append_path "CMAKE_PREFIX_PATH", "#{MacOS.sdk_path}/usr/X11"
    end

    append "CFLAGS", "-I#{MacOS::X11.include}" unless MacOS::CLT.installed?
  end
  alias_method :libpng, :x11

  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags "-w"
  end

  def m64
    append_to_cflags "-m64"
    append "LDFLAGS", "-arch #{Hardware::CPU.arch_64_bit}"
  end

  def m32
    append_to_cflags "-m32"
    append "LDFLAGS", "-arch #{Hardware::CPU.arch_32_bit}"
  end

  def universal_binary
    check_for_compiler_universal_support

    append_to_cflags Hardware::CPU.universal_archs.as_arch_flags
    append "LDFLAGS", Hardware::CPU.universal_archs.as_arch_flags

    if compiler != :clang && Hardware.is_32_bit?
      # Can't mix "-march" for a 32-bit CPU  with "-arch x86_64"
      replace_in_cflags(/-march=\S*/, "-Xarch_#{Hardware::CPU.arch_32_bit} \\0")
    end
  end

  def cxx11
    if compiler == :clang
      append "CXX", "-std=c++11"
      append "CXX", "-stdlib=libc++"
    elsif compiler =~ /gcc-(4\.(8|9)|5)/
      append "CXX", "-std=c++11"
    else
      raise "The selected compiler doesn't support C++11: #{compiler}"
    end
  end

  def libcxx
    if compiler == :clang
      append "CXX", "-stdlib=libc++"
    end
  end

  def libstdcxx
    if compiler == :clang
      append "CXX", "-stdlib=libstdc++"
    end
  end

  # @private
  def replace_in_cflags(before, after)
    CC_FLAG_VARS.each do |key|
      self[key] = self[key].sub(before, after) if key?(key)
    end
  end

  # Convenience method to set all C compiler flags in one shot.
  def set_cflags(val)
    CC_FLAG_VARS.each { |key| self[key] = val }
  end

  # Sets architecture-specific flags for every environment variable
  # given in the list `flags`.
  # @private
  def set_cpu_flags(flags, default = DEFAULT_FLAGS, map = Hardware::CPU.optimization_flags)
    cflags =~ /(-Xarch_#{Hardware::CPU.arch_32_bit} )-march=/
    xarch = $1.to_s
    remove flags, /(-Xarch_#{Hardware::CPU.arch_32_bit} )?-march=\S*/
    remove flags, /( -Xclang \S+)+/
    remove flags, /-mssse3/
    remove flags, /-msse4(\.\d)?/
    append flags, xarch unless xarch.empty?
    append flags, map.fetch(effective_arch, default)
  end

  # @private
  def effective_arch
    if ARGV.build_bottle?
      ARGV.bottle_arch || Hardware.oldest_cpu
    elsif Hardware::CPU.intel? && !Hardware::CPU.sse4?
      # If the CPU doesn't support SSE4, we cannot trust -march=native or
      # -march=<cpu family> to do the right thing because we might be running
      # in a VM or on a Hackintosh.
      Hardware.oldest_cpu
    else
      Hardware::CPU.family
    end
  end

  # @private
  def set_cpu_cflags(default = DEFAULT_FLAGS, map = Hardware::CPU.optimization_flags)
    set_cpu_flags CC_FLAG_VARS, default, map
  end

  def make_jobs
    # '-j' requires a positive integral argument
    if self["HOMEBREW_MAKE_JOBS"].to_i > 0
      self["HOMEBREW_MAKE_JOBS"].to_i
    else
      Hardware::CPU.cores
    end
  end

  # This method does nothing in stdenv since there's no arg refurbishment
  # @private
  def refurbish_args; end
end
