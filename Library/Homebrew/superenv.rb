require 'extend/ENV'
require 'macos'

### Why `superenv`?
# 1) Only specify the environment we need (NO LDFLAGS for cmake)
# 2) Only apply compiler specific options when we are calling that compiler
# 3) Force all incpaths and libpaths into the cc instantiation (less bugs)
# 4) Cater toolchain usage to specific Xcode versions
# 5) Remove flags that we don't want or that will break builds
# 6) Simpler code
# 7) Simpler formula that *just work*
# 8) Build-system agnostic configuration of the tool-chain

def superbin
  @bin ||= (HOMEBREW_REPOSITORY/"Library/ENV").children.reject{|d| d.basename.to_s > MacOS::Xcode.version }.max
end

def superenv?
  not MacOS::Xcode.folder.nil? and # because xcrun won't work
  superbin and superbin.directory? and
  not ARGV.include? "--env=std"
end

class << ENV
  attr_accessor :keg_only_deps, :deps, :x11
  alias_method :x11?, :x11

  def reset
    %w{CC CXX OBJC OBJCXX CPP MAKE LD
      CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS LDFLAGS CPPFLAGS
      MACOS_DEPLOYMENT_TARGET SDKROOT
      CMAKE_PREFIX_PATH CMAKE_INCLUDE_PATH CMAKE_FRAMEWORK_PATH
      CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH}.
      each{ |x| delete(x) }
    delete('CDPATH') # avoid make issues that depend on changing directories
    delete('GREP_OPTIONS') # can break CMake
    delete('CLICOLOR_FORCE') # autotools doesn't like this
  end

  def setup_build_environment
    reset
    check
    ENV['CC'] = 'cc'
    ENV['CXX'] = 'c++'
    ENV['OBJC'] = 'cc'
    ENV['OBJCXX'] = 'c++'
    ENV['DEVELOPER_DIR'] = determine_developer_dir # effects later settings
    ENV['MAKEFLAGS'] ||= "-j#{determine_make_jobs}"
    ENV['PATH'] = determine_path
    ENV['PKG_CONFIG_PATH'] = determine_pkg_config_path
    ENV['PKG_CONFIG_LIBDIR'] = determine_pkg_config_libdir
    ENV['HOMEBREW_CC'] = determine_cc
    ENV['HOMEBREW_CCCFG'] = determine_cccfg
    ENV['HOMEBREW_BREW_FILE'] = HOMEBREW_BREW_FILE
    ENV['HOMEBREW_SDKROOT'] = "#{MacOS.sdk_path}" if MacSystem.xcode43_without_clt?
    ENV['CMAKE_PREFIX_PATH'] = determine_cmake_prefix_path
    ENV['CMAKE_FRAMEWORK_PATH'] = "#{MacOS.sdk_path}/System/Library/Frameworks" if MacSystem.xcode43_without_clt?
    ENV['CMAKE_INCLUDE_PATH'] = determine_cmake_include_path
    ENV['CMAKE_LIBRARY_PATH'] = determine_cmake_library_path
    ENV['ACLOCAL_PATH'] = determine_aclocal_path
  end

  def check
    raise if MacSystem.xcode43_without_clt? and MacOS.sdk_path.nil?
  end

  def universal_binary
    append 'HOMEBREW_CCCFG', "u", ''
  end

  # m32 on superenv does not add any flags. It prevents "-m32" from being erased.
  def m32
    append 'HOMEBREW_CCCFG', "3", ''
  end

  private

  def determine_cc
    if ARGV.include? '--use-gcc'
      # fall back to something else on systems without Apple gcc
      MacOS.locate('gcc-4.2') ? "gcc-4.2" : raise("gcc-4.2 not found!")
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
    "clang"
  end

  def determine_path
    paths = [superbin]
    if MacSystem.xcode43_without_clt?
      paths << "#{MacSystem.xcode43_developer_dir}/usr/bin"
      paths << "#{MacSystem.xcode43_developer_dir}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
    end
    paths += deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/bin" }
    paths << "#{HOMEBREW_PREFIX}/opt/python/bin" if brewed_python?
    paths << "#{MacSystem.x11_prefix}/bin" if x11?
    paths += %w{/usr/bin /bin /usr/sbin /sbin}
    paths.to_path_s
  end

  def determine_pkg_config_path
    paths  = deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/lib/pkgconfig" }
    paths += deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/share/pkgconfig" }
    paths.to_path_s
  end

  def determine_pkg_config_libdir
    paths = %W{/usr/lib/pkgconfig #{HOMEBREW_REPOSITORY}/Library/ENV/pkgconfig/#{MacOS.version}}
    paths << "#{MacSystem.x11_prefix}/lib/pkgconfig" << "#{MacSystem.x11_prefix}/share/pkgconfig" if x11?
    paths.to_path_s
  end

  def determine_cmake_prefix_path
    paths = keg_only_deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}" }
    paths << HOMEBREW_PREFIX.to_s # put ourselves ahead of everything else
    paths << "#{MacOS.sdk_path}/usr" if MacSystem.xcode43_without_clt?
    paths.to_path_s
  end

  def determine_cmake_include_path
    sdk = MacOS.sdk_path if MacSystem.xcode43_without_clt?
    paths = []
    paths << "#{MacSystem.x11_prefix}/include/freetype2" if x11?
    paths << "#{sdk}/usr/include/libxml2" unless deps.include? 'libxml2'
    if MacSystem.xcode43_without_clt?
      paths << "#{sdk}/usr/include/apache2"
      paths << if brewed_python?
        "#{HOMEBREW_PREFIX}/opt/python/Frameworks/Python.framework/Headers"
      else
        "#{sdk}/System/Library/Frameworks/Python.framework/Versions/Current/include/python2.7"
      end
    end
    paths << "#{sdk}/System/Library/Frameworks/OpenGL.framework/Versions/Current/Headers/" unless x11?
    paths << "#{MacSystem.x11_prefix}/include" if x11?
    paths.to_path_s
  end

  def determine_cmake_library_path
    sdk = MacOS.sdk_path if MacSystem.xcode43_without_clt?
    paths = []
    # things expect to find GL headers since X11 used to be a default, so we add them
    paths << "#{sdk}/System/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries" unless x11?
    paths << "#{MacSystem.x11_prefix}/lib" if x11?
    paths.to_path_s
  end

  def determine_aclocal_path
    paths = keg_only_deps.map{|dep| "#{HOMEBREW_PREFIX}/opt/#{dep}/share/aclocal" }
    paths << "#{HOMEBREW_PREFIX}/share/aclocal"
    paths << "/opt/X11/share/aclocal" if x11?
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
    s << 'b' if ARGV.build_bottle?
    # Fix issue with sed barfing on unicode characters on Mountain Lion
    s << 's' if MacOS.version >= :mountain_lion
    # Fix issue with 10.8 apr-1-config having broken paths
    s << 'a' if MacOS.version == :mountain_lion
    s
  end

  def determine_developer_dir
    # If Xcode path is fucked then this is basically a fix. In the case where
    # nothing is valid, it still fixes most usage to supply a valid path that
    # is not "/".
    if MacOS::Xcode.bad_xcode_select_path?
      (MacOS::Xcode.prefix || HOMEBREW_PREFIX).to_s
    elsif ENV['DEVELOPER_DIR']
      ENV['DEVELOPER_DIR']
    end
  end

  def brewed_python?
    require 'formula'
    Formula.factory('python').linked_keg.directory?
  end

  public

### NO LONGER NECESSARY OR NO LONGER SUPPORTED
  def noop(*args); end
  %w[m64 gcc_4_0_1 fast O4 O3 O2 Os Og O1 libxml2 minimal_optimization
    no_optimization enable_warnings x11
    set_cpu_flags
    macosxsdk remove_macosxsdk].each{|s| alias_method s, :noop }

### DEPRECATE THESE
  def compiler
    case ENV['HOMEBREW_CC']
      when "llvm-gcc" then :llvm
      when "gcc-4.2" then :gcc
      when "gcc", "clang" then ENV['HOMEBREW_CC'].to_sym
    else
      raise
    end
  end
  def deparallelize
    delete('MAKEFLAGS')
  end
  alias_method :j1, :deparallelize
  def gcc
    ENV['CC'] = ENV['OBJC'] = ENV['HOMEBREW_CC'] = "gcc"
    ENV['CXX'] = ENV['OBJCXX'] = "g++"
  end
  def llvm
    ENV['CC'] = ENV['OBJC'] = ENV['HOMEBREW_CC'] = "llvm-gcc"
    ENV['CXX'] = ENV['OBJCXX'] = "g++"
  end
  def clang
    ENV['CC'] = ENV['OBJC'] = ENV['HOMEBREW_CC'] = "clang"
    ENV['CXX'] = ENV['OBJCXX'] = "clang++"
  end
  def make_jobs
    ENV['MAKEFLAGS'] =~ /-\w*j(\d)+/
    [$1.to_i, 1].max
  end

  # Many formula assume that CFLAGS etc. will not be nil.
  # This should be a safe hack to prevent that exception cropping up.
  # Main consqeuence of this is that ENV['CFLAGS'] is never nil even when it
  # is which can break if checks, but we don't do such a check in our code.
  def [] key
    if has_key? key
      fetch(key)
    elsif %w{CPPFLAGS CFLAGS LDFLAGS}.include? key
      class << (a = "")
        attr_accessor :key
        def + value
          ENV[key] = value
        end
        alias_method '<<', '+'
      end
      a.key = key
      a
    end
  end

end if superenv?


if not superenv?
  ENV.extend(HomebrewEnvExtension)
  # we must do this or tools like pkg-config won't get found by configure scripts etc.
  ENV.prepend 'PATH', "#{HOMEBREW_PREFIX}/bin", ':' unless ORIGINAL_PATHS.include? HOMEBREW_PREFIX/'bin'
else
  ENV.keg_only_deps = []
  ENV.deps = []
end


class Array
  def to_path_s
    map(&:to_s).uniq.select{|s| File.directory? s }.join(':').chuzzle
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
    @x11_prefix ||= %W[/opt/X11 /usr/X11
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
