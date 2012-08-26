module MacOS extend self

  MDITEM_BUNDLE_ID_KEY = "kMDItemCFBundleIdentifier"

  def version
    require 'version'
    MacOSVersion.new(MACOS_VERSION.to_s)
  end

  def cat
<<<<<<< HEAD
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
=======
    if version == :mountain_lion then :mountainlion
    elsif version == :lion then :lion
    elsif version == :snow_leopard then :snowleopard
    elsif version == :leopard then :leopard
    else nil
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    end
  end

  def locate tool
    # Don't call tools (cc, make, strip, etc.) directly!
    # Give the name of the binary you look for as a string to this method
    # in order to get the full path back as a Pathname.
    @locate ||= {}
    @locate[tool.to_s] ||= if File.executable? "/usr/bin/#{tool}"
      Pathname.new "/usr/bin/#{tool}"
    else
<<<<<<< HEAD
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
=======
      # If the tool isn't in /usr/bin, then we first try to use xcrun to find
      # it. If it's not there, or xcode-select is misconfigured, we have to
      # look in dev_tools_path, and finally in xctoolchain_path, because the
      # tools were split over two locations beginning with Xcode 4.3+.
      xcrun_path = unless Xcode.bad_xcode_select_path?
        `/usr/bin/xcrun -find #{tool} 2>/dev/null`.chomp
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      end

      paths = %W[#{xcrun_path}
                 #{dev_tools_path}/#{tool}
                 #{xctoolchain_path}/usr/bin/#{tool}]
      paths.map { |p| Pathname.new(p) }.find { |p| p.executable? }
    end
  end

  def dev_tools_path
    @dev_tools_path ||= if File.exist? "/usr/bin/cc" and File.exist? "/usr/bin/make"
      # probably a safe enough assumption (the unix way)
      Pathname.new "/usr/bin"
<<<<<<< HEAD
    elsif not Xcode.bad_xcode_select_path? and system "/usr/bin/xcrun -find make 1>/dev/null 2>&1"
=======
    # Note that the exit status of system "xcrun foo" isn't always accurate
    elsif not Xcode.bad_xcode_select_path? and not `/usr/bin/xcrun -find make 2>/dev/null`.empty?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      # Wherever "make" is there are the dev tools.
      Pathname.new(`/usr/bin/xcrun -find make`.chomp).dirname
    elsif File.exist? "#{Xcode.prefix}/usr/bin/make"
      # cc stopped existing with Xcode 4.3, there are c89 and c99 options though
      Pathname.new "#{Xcode.prefix}/usr/bin"
    else
      # Since we are pretty unrelenting in finding Xcode no matter where
      # it hides, we can now throw in the towel.
      opoo "Could not locate developer tools. Consult `brew doctor`."
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

<<<<<<< HEAD
<<<<<<< HEAD
  def xcode_prefix
    @xcode_prefix ||= begin
      path = Pathname.new xcode_folder
      if $?.success? and path.absolute? and File.executable? "#{path}/usr/bin/make"
        path
      elsif File.executable? '/Developer/usr/bin/make'
        # we do this to support cowboys who insist on installing
        # only a subset of Xcode
        Pathname.new '/Developer'
      elsif File.executable? '/Applications/Xcode.app/Contents/Developer/usr/bin/make'
        # fallback for broken Xcode 4.3 installs
        Pathname.new '/Applications/Xcode.app/Contents/Developer'
      else
        # Ask Spotlight where Xcode is. If the user didn't install the
        # helper tools and installed Xcode in a non-conventional place, this
        # is our only option. See: http://superuser.com/questions/390757
        path = app_with_bundle_id(XCODE_4_BUNDLE_ID) || app_with_bundle_id(XCODE_3_BUNDLE_ID)

        unless path.nil?
          path += "Contents/Developer"
          path if File.executable? "#{path}/usr/bin/make"
        end
      end
    end
  end

  def xcode_installed?
    # Telling us whether the Xcode.app is installed or not.
    @xcode_installed ||= File.directory?('/Applications/Xcode.app') ||
      File.directory?('/Developer/Applications/Xcode.app') ||
      app_with_bundle_id(XCODE_4_BUNDLE_ID) ||
      app_with_bundle_id(XCODE_3_BUNDLE_ID) ||
      false
  end

  def xcode_version
    # may return a version string
    # that is guessed based on the compiler, so do not
    # use it in order to check if Xcode is installed.
    @xcode_version ||= begin
      return "0" unless MACOS

      # this shortcut makes xcode_version work for people who don't realise you
      # need to install the CLI tools
      xcode43build = "/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild"
      if File.file? xcode43build
        `#{xcode43build} -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
        return $1 if $1
      end

      # Xcode 4.3 xc* tools hang indefinately if xcode-select path is set thus
      raise if xctools_fucked?

      raise unless which "xcodebuild"
      `xcodebuild -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
      raise if $1.nil? or not $?.success?
      $1
    rescue
      # For people who's xcode-select is unset, or who have installed
      # xcode-gcc-installer or whatever other combinations we can try and
      # supprt. See https://github.com/mxcl/homebrew/wiki/Xcode
      case llvm_build_version.to_i
      when 1..2063 then "3.1.0"
      when 2064..2065 then "3.1.4"
      when 2366..2325
        # we have no data for this range so we are guessing
        "3.2.0"
      when 2326
        # also applies to "3.2.3"
        "3.2.4"
      when 2327..2333 then "3.2.5"
      when 2335
        # this build number applies to 3.2.6, 4.0 and 4.1
        # https://github.com/mxcl/homebrew/wiki/Xcode
        "4.0"
      else
        case (clang_version.to_f * 10).to_i
        when 0
          "dunno"
        when 1..14
          "3.2.2"
        when 15
          "3.2.4"
        when 16
          "3.2.5"
        when 17..20
          "4.0"
        when 21
          "4.1"
        when 22..30
          "4.2"
        when 31
          "4.3"
        when 40
          "4.4"
        else
          "4.4"
        end
      end
    end
  end

=======
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
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

  def prefer_64_bit?
    Hardware.is_64_bit? and version != :leopard
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
    "4.4" => {:llvm_build_version=>2336, :clang_version=>"4.0", :clang_build_version=>421},
    "4.4.1" => {:llvm_build_version=>2336, :clang_version=>"4.0", :clang_build_version=>421}
  }

  def compilers_standard?
    xcode = Xcode.version
<<<<<<< HEAD
    # Assume compilers are okay if Xcode version not in hash
    return true unless StandardCompilers.keys.include? xcode
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

    unless StandardCompilers.keys.include? xcode
      onoe <<-EOS.undent
        Homebrew doesn't know what compiler versions ship with your version of
        Xcode. Please file an issue with the output of `brew --config`:
          https://github.com/mxcl/homebrew/issues

        Thanks!
        EOS
    end

    StandardCompilers[xcode].all? { |method, build| MacOS.send(method) == build }
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

  def bottles_supported?
    # We support bottles on all versions of OS X except 32-bit Snow Leopard.
    (Hardware.is_64_bit? or not MacOS.snow_leopard?) \
      and HOMEBREW_PREFIX.to_s == '/usr/local' \
      and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar' \
  end
end

require 'macos/xcode'
require 'macos/xquartz'
