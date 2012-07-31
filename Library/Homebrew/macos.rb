module MacOS extend self

  MDITEM_BUNDLE_ID_KEY = "kMDItemCFBundleIdentifier"
  APPLE_X11_BUNDLE_ID = "org.x.X11"
  XQUARTZ_BUNDLE_ID = "org.macosforge.xquartz.X11"

  def version
    MACOS_VERSION
  end

  def cat
    if mountain_lion?
      :mountainlion
    elsif lion?
      :lion
    elsif snow_leopard?
      :snowleopard
    elsif leopard?
      :leopard
    else
      nil
    end
  end

  def locate tool
    # Don't call tools (cc, make, strip, etc.) directly!
    # Give the name of the binary you look for as a string to this method
    # in order to get the full path back as a Pathname.
    tool = tool.to_s

    @locate_cache ||= {}
    return @locate_cache[tool] if @locate_cache.has_key? tool

    if File.executable? "/usr/bin/#{tool}"
      path = Pathname.new "/usr/bin/#{tool}"
    else
      # Xcrun was provided first with Xcode 4.3 and allows us to proxy
      # tool usage thus avoiding various bugs.
      p = `/usr/bin/xcrun -find #{tool} 2>/dev/null`.chomp unless Xcode.bad_xcode_select_path?
      if !p.nil? and !p.empty? and File.executable? p
        path = Pathname.new p
      else
        # This is for the use-case where xcode-select is not set up correctly
        # with Xcode 4.3+. The tools in Xcode 4.3+ are split over two locations,
        # usually xcrun would figure that out for us, but it won't work if
        # xcode-select is not configured properly.
        p = "#{dev_tools_path}/#{tool}"
        if File.executable? p
          path = Pathname.new p
        else
          # Otherwise lets look in the second location.
          p = "#{xctoolchain_path}/usr/bin/#{tool}"
          if File.executable? p
            path = Pathname.new p
          else
            # We digged so deep but all is lost now.
            path = nil
          end
        end
      end
    end
    @locate_cache[tool] = path
    return path
  end

  def dev_tools_path
    @dev_tools_path ||= if File.exist? "/usr/bin/cc" and File.exist? "/usr/bin/make"
      # probably a safe enough assumption (the unix way)
      Pathname.new "/usr/bin"
    elsif not Xcode.bad_xcode_select_path? and system "/usr/bin/xcrun -find make 1>/dev/null 2>&1"
      # Wherever "make" is there are the dev tools.
      Pathname.new(`/usr/bin/xcrun -find make`.chomp).dirname
    elsif File.exist? "#{Xcode.prefix}/usr/bin/make"
      # cc stopped existing with Xcode 4.3, there are c89 and c99 options though
      Pathname.new "#{Xcode.prefix}/usr/bin"
    else
      # Since we are pretty unrelenting in finding Xcode no matter where
      # it hides, we can now throw in the towel.
      opoo "You really should consult the `brew doctor`!"
      ""
    end
  end

  def xctoolchain_path
    # As of Xcode 4.3, some tools are located in the "xctoolchain" directory
    @xctoolchain_path ||= begin
      path = Pathname.new("#{Xcode.prefix}/Toolchains/XcodeDefault.xctoolchain")
      # If only the CLT are installed, all tools will be under dev_tools_path,
      # this path won't exist, and xctoolchain_path will be nil.
      path if path.exist?
    end
  end

  def sdk_path v=version
    @sdk_path ||= {}
    @sdk_path[v.to_s] ||= begin
      path = if not Xcode.bad_xcode_select_path? and File.executable? "#{Xcode.folder}/usr/bin/make"
        `#{locate('xcodebuild')} -version -sdk macosx#{v} Path 2>/dev/null`.strip
      elsif File.directory? "/Developer/SDKs/MacOS#{v}.sdk"
        # the old default (or wild wild west style)
        "/Developer/SDKs/MacOS#{v}.sdk"
      elsif File.directory? "#{Xcode.prefix}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX#{v}.sdk"
        # Xcode.prefix is pretty smart, so lets look inside to find the sdk
        "#{Xcode.prefix}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX#{v}.sdk"
      end

      Pathname.new(path) unless path.nil? or path.empty? or not File.directory? path
    end
  end

  def default_cc
    cc = locate 'cc'
    Pathname.new(cc).realpath.basename.to_s rescue nil
  end

  def default_compiler
    case default_cc
      when /^gcc/ then :gcc
      when /^llvm/ then :llvm
      when "clang" then :clang
      else
        # guess :(
        if Xcode.version >= "4.3"
          :clang
        elsif Xcode.version >= "4.2"
          :llvm
        else
          :gcc
        end
    end
  end

  def gcc_40_build_version
    @gcc_40_build_version ||= if locate("gcc-4.0")
      `#{locate("gcc-4.0")} --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  def gcc_42_build_version
    @gcc_42_build_version ||= if locate("gcc-4.2") \
      and not locate("gcc-4.2").realpath.basename.to_s =~ /^llvm/
      `#{locate("gcc-4.2")} --version` =~ /build (\d{4,})/
      $1.to_i
    end
  end

  def llvm_build_version
    # for Xcode 3 on OS X 10.5 this will not exist
    # NOTE may not be true anymore but we can't test
    @llvm_build_version ||= if locate("llvm-gcc")
      `#{locate("llvm-gcc")} --version` =~ /LLVM build (\d{4,})/
      $1.to_i
    end
  end

  def clang_version
    @clang_version ||= if locate("clang")
      `#{locate("clang")} --version` =~ /clang version (\d\.\d)/
      $1
    end
  end

  def clang_build_version
    @clang_build_version ||= if locate("clang")
      `#{locate("clang")} --version` =~ %r[tags/Apple/clang-(\d{2,})]
      $1.to_i
    end
  end

  def xquartz_version
    # This returns the version number of XQuartz, not of the upstream X.org
    # (which is why it is not called x11_version). Note that the X11.app
    # distributed by Apple is also XQuartz, and therefore covered by this method.
    path = app_with_bundle_id(XQUARTZ_BUNDLE_ID) || app_with_bundle_id(APPLE_X11_BUNDLE_ID)
    version = if not path.nil? and path.exist?
      `mdls -raw -name kMDItemVersion #{path}`.strip
    end
  end

  def x11_prefix
    @x11_prefix ||= if Pathname.new('/opt/X11/lib/libpng.dylib').exist?
      Pathname.new('/opt/X11')
    elsif Pathname.new('/usr/X11/lib/libpng.dylib').exist?
      Pathname.new('/usr/X11')
    end
  end

  def x11_installed?
    not x11_prefix.nil?
  end

  def macports_or_fink_installed?
    # See these issues for some history:
    # http://github.com/mxcl/homebrew/issues/#issue/13
    # http://github.com/mxcl/homebrew/issues/#issue/41
    # http://github.com/mxcl/homebrew/issues/#issue/48
    return false unless MACOS

    %w[port fink].each do |ponk|
      path = which(ponk)
      return ponk unless path.nil?
    end

    # we do the above check because macports can be relocated and fink may be
    # able to be relocated in the future. This following check is because if
    # fink and macports are not in the PATH but are still installed it can
    # *still* break the build -- because some build scripts hardcode these paths:
    %w[/sw/bin/fink /opt/local/bin/port].each do |ponk|
      return ponk if File.exist? ponk
    end

    # finally, sometimes people make their MacPorts or Fink read-only so they
    # can quickly test Homebrew out, but still in theory obey the README's
    # advise to rename the root directory. This doesn't work, many build scripts
    # error out when they try to read from these now unreadable directories.
    %w[/sw /opt/local].each do |path|
      path = Pathname.new(path)
      return path if path.exist? and not path.readable?
    end

    false
  end

  def leopard?
    10.5 == MACOS_VERSION
  end

  def snow_leopard?
    10.6 <= MACOS_VERSION # Actually Snow Leopard or newer
  end

  def lion?
    10.7 <= MACOS_VERSION # Actually Lion or newer
  end

  def mountain_lion?
    10.8 <= MACOS_VERSION # Actually Mountain Lion or newer
  end

  def prefer_64_bit?
    Hardware.is_64_bit? and not leopard?
  end

  StandardCompilers = {
    "3.1.4" => {:gcc_40_build_version=>5493, :gcc_42_build_version=>5577},
    "3.2.6" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"1.7", :clang_build_version=>77},
    "4.0" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.0.1" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.0.2" => {:gcc_40_build_version=>5494, :gcc_42_build_version=>5666, :llvm_build_version=>2335, :clang_version=>"2.0", :clang_build_version=>137},
    "4.2" => {:llvm_build_version=>2336, :clang_version=>"3.0", :clang_build_version=>211},
    "4.3" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.1" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.2" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.3.3" => {:llvm_build_version=>2336, :clang_version=>"3.1", :clang_build_version=>318},
    "4.4" => {:llvm_build_version=>2336, :clang_version=>"4.0", :clang_build_version=>421}
  }

  def compilers_standard?
    xcode = Xcode.version
    # Assume compilers are okay if Xcode version not in hash
    return true unless StandardCompilers.keys.include? xcode

    StandardCompilers[xcode].all? {|k,v| MacOS.send(k) == v}
  end

  def app_with_bundle_id id
    mdfind(MDITEM_BUNDLE_ID_KEY, id)
  end

  def mdfind attribute, id
    path = `mdfind "#{attribute} == '#{id}'"`.split("\n").first
    Pathname.new(path) unless path.nil? or path.empty?
  end

  def pkgutil_info id
    `pkgutil --pkg-info #{id} 2>/dev/null`.strip
  end
end

require 'xcode'
