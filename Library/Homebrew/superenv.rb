require 'extend/ENV'

### Why `superenv`?
# 1) Only specify the environment we need (NO LDFLAGS for cmake)
# 2) Only apply compiler specific options when we are calling that compiler
# 3) Force all incpaths and libpaths into the cc instantiation (less bugs)
# 4) Cater toolchain usage to specific Xcode versions
# 5) Remove flags that we don't want or that will break builds
# 6) Simpler code
# 7) Simpler formula that *just work*
# 8) Build-system agnostic configuration of the tool-chain
# 9) No messing around trying to force build systems to use a particular cc

def superenv_bin
  @bin ||= (HOMEBREW_REPOSITORY/"Library/x").children.reject{|d| d.basename.to_s > MacOS::Xcode.version }.max
end

def superenv?
  superenv_bin.directory? and not ARGV.include? "--lame-env"
end

class << ENV
  attr :deps, true

  def reset
    %w{CC CXX LD CPP OBJC MAKE
      CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS
      MACOS_DEPLOYMENT_TARGET SDKROOT
      CMAKE_PREFIX_PATH CMAKE_INCLUDE_PATH CMAKE_FRAMEWORK_PATH}.
      each{ |x| delete(x) }
    delete('CDPATH') # avoid make issues that depend on changing directories
    delete('GREP_OPTIONS') # can break CMake
    delete('CLICOLOR_FORCE') # autotools doesn't like this
  end

  def setup_build_environment
    reset
    ENV['CC'] = determine_cc
    ENV['CXX'] = determine_cxx
    ENV['LD'] = 'ld'
    ENV['CPP'] = 'cpp'
    ENV['MAKE'] = 'make'
    ENV['MAKEFLAGS'] ||= "-j#{determine_make_jobs}"
    ENV['PATH'] = determine_path
    ENV['PKG_CONFIG_PATH'] = determine_pkg_config_path
    ENV['HOMEBREW_CCCFG'] = determine_cccfg
    ENV['HOMEBREW_SDKROOT'] = "#{MacOS.sdk_path}" if MacSystem.xcode43_without_clt?
    ENV['CMAKE_PREFIX_PATH'] = determine_cmake_prefix_path
    ENV['CMAKE_FRAMEWORK_PATH'] = "#{MacOS.sdk_path}/System/Library/Frameworks" if MacSystem.xcode43_without_clt?
    ENV['CMAKE_INCLUDE_PATH'] = determine_cmake_include_path
    ENV['ACLOCAL_PATH'] = determine_aclocal_path
  end

  def universal_binary
    append 'HOMEBREW_CCCFG', "u", ''
  end

  def make_me_some_cflags
    prefixes = determine_cmake_prefix_path.split(':')
    prefixes.map{|s| "-I#{s}/include -L#{s}/lib" }.join(" ")
  end

  private

  def determine_cc
    if ARGV.include? '--use-gcc'
      "gcc"
    elsif ARGV.include? '--use-llvm'
      "llvm-gcc"
    elsif ARGV.include? '--use-clang'
      "clang"
    elsif ENV['HOMEBREW_USE_CLANG']
      opoo %{HOMEBREW_USE_CLANG is deprecated, use HOMEBREW_CC="clang" instead}
      "clang"
    elsif ENV['HOMEBREW_USE_LLVM']
      opoo %{HOMEBREW_USE_LLVM is deprecated, use HOMEBREW_CC="llvm" instead}
      "llvm-gcc"
    elsif ENV['HOMEBREW_USE_GCC']
      opoo %{HOMEBREW_USE_GCC is deprecated, use HOMEBREW_CC="gcc" instead}
      "gcc"
    elsif ENV['HOMEBREW_CC']
      case ENV['HOMEBREW_CC']
        when 'clang', 'gcc' then ENV['HOMEBREW_CC']
        when 'llvm', 'llvm-gcc' then 'llvm-gcc'
      else
        opoo "Invalid value for HOMEBREW_CC: #{ENV['HOMEBREW_CC']}"
        raise # use default
      end
    else
      raise
    end
  rescue
    # Don't specify 'clang', eg. dirac detects for `cl*)` (the windows
    # compiler) in its (broken) configure.
    "cc"
  end

  def determine_cxx
    case cc.to_s
      when "clang" then "clang++"
      when "llvm-gcc" then "llvm-g++"
      when "gcc" then "g++"
    else
      "c++"
    end
  end

  def determine_path
    paths = [superenv_bin]
    if MacSystem.xcode43_without_clt?
      paths << "#{MacSystem.xcode43_developer_dir}/usr/bin"
      paths << "#{MacSystem.xcode43_developer_dir}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
    end
    paths += deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/bin" }
    paths << HOMEBREW_PREFIX/:bin
    paths << "#{MacSystem.x11_prefix}/bin"
    paths += %w{/usr/bin /bin /usr/sbin /sbin}
    paths.to_path_s
  end

  def determine_pkg_config_path
    paths  = deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/lib/pkgconfig" }
    paths += deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/share/pkgconfig" }
    paths << "#{HOMEBREW_REPOSITORY}/lib/pkgconfig"
    paths << "#{HOMEBREW_REPOSITORY}/share/pkgconfig"
    # we put our paths before X because we dupe some of the X libraries
    paths << "#{MacSystem.x11_prefix}/lib/pkgconfig" << "#{MacSystem.x11_prefix}/share/pkgconfig"
    # Mountain Lion no longer ships some .pcs; ensure we pick up our versions
    paths << "#{HOMEBREW_REPOSITORY}/Library/Homebrew/pkgconfig" if MacOS.mountain_lion?
    paths.to_path_s
  end

  def determine_cmake_prefix_path
    paths = deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}" }
    paths << "#{MacOS.sdk_path}/usr" if MacSystem.xcode43_without_clt?
    paths << HOMEBREW_PREFIX.to_s # again always put ourselves ahead of X11
    paths << MacSystem.x11_prefix
    paths.to_path_s
  end

  def determine_cmake_include_path
    sdk = MacOS.sdk_path if MacSystem.xcode43_without_clt?
    paths = %W{#{MacSystem.x11_prefix}/include/freetype2}
    paths << "#{sdk}/usr/include/libxml2" unless deps.include? 'libxml2'
    # TODO prolly shouldn't always do this?
    paths << "#{sdk}/System/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7" if MacSystem.xcode43_without_clt?
    paths.to_path_s
  end

  def determine_aclocal_path
    paths = deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/share/aclocal" }
    paths << "#{HOMEBREW_PREFIX}/share/aclocal"
    paths << "/opt/X11/share/aclocal"
    paths.to_path_s
  end

  def determine_make_jobs
    if (j = ENV['HOMEBREW_MAKE_JOBS'].to_i) < 1
      Hardware.processor_count
    else
      j
    end
  end

  def determine_cccfg
    s = ""
    # Fix issue with sed barfing on unicode characters on Mountain Lion
    s << 's' if MacOS.mountain_lion?
    s << 'b' if ARGV.build_bottle?
    s
  end

  public

### NO LONGER NECESSARY OR NO LONGER SUPPORTED
  def noop; end
  %w[m64 m32 gcc_4_0_1 fast O4 O3 O2 Os Og O1 libxml2 x11 minimal_optimization
    no_optimization enable_warnings fortran].each{|s| alias_method s, :noop }

### DEPRECATE THESE
  def compiler
    case ENV['CC']
      when "llvm-gcc" then :llvm
      when "gcc", "clang" then ENV['CC'].to_sym
      when "cc", nil then MacOS.default_compiler
    else
      raise
    end
  end
  def deparallelize
    delete('MAKEFLAGS')
  end
  alias_method :j1, :deparallelize
  def gcc
    ENV['CC'] = "gcc"
    ENV['CXX'] = "g++"
  end
  def llvm
    ENV['CC'] = "llvm-gcc"
    ENV['CXX'] = "llvm-g++"
  end
  def clang
    ENV['CC'] = "clang"
    ENV['CXX'] = "clang++"
  end
  def make_jobs
    ENV['MAKEFLAGS'] =~ /-\w*j(\d)+/
    [$1.to_i, 1].max
  end

end if superenv?


if not superenv?
  ENV.extend(HomebrewEnvExtension)
  # we must do this or tools like pkg-config won't get found by configure scripts etc.
  ENV.prepend 'PATH', "#{HOMEBREW_PREFIX}/bin", ':' unless ORIGINAL_PATHS.include? HOMEBREW_PREFIX/'bin'
else
  ENV.deps = []
end


class Array
  def to_path_s
    map(&:to_s).select{|s| s and File.directory? s }.join(':').chuzzle
  end
end

# new code because I don't really trust the Xcode code now having researched it more
module MacSystem extend self
  def xcode_clt_installed?
    File.executable? "/usr/bin/clang" and File.executable? "/usr/bin/lldb"
  end

  def xcode43_without_clt?
    MacOS::Xcode.version >= "4.3" and not MacSystem.xcode_clt_installed?
  end

  def x11_prefix
    @x11_prefix ||= %W[/usr/X11 /opt/X11
      #{MacOS.sdk_path}/usr/X11].find{|path| File.directory? "#{path}/include" }
  end

  def xcode43_developer_dir
    @xcode43_developer_dir ||=
      tst(ENV['DEVELOPER_DIR']) ||
      tst(`xcode-select -print-path 2>/dev/null`) ||
      tst("/Applications/Xcode.app/Contents/Developer") ||
      MacOS.mdfind("com.apple.dt.Xcode").find{|path| tst(path) }
    raise unless @xcode43_developer_dir
    @xcode43_developer_dir
  end

  private

  def tst prefix
    prefix = prefix.to_s.chomp
    xcrun = "#{prefix}/usr/bin/xcrun"
    prefix if xcrun != "/usr/bin/xcrun" and File.executable? xcrun
  end
end
