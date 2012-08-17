module MacOS::Xcode extend self

  V4_BUNDLE_ID = "com.apple.dt.Xcode"
  V3_BUNDLE_ID = "com.apple.Xcode"
  V4_BUNDLE_PATH = Pathname.new("/Applications/Xcode.app")
  V3_BUNDLE_PATH = Pathname.new("/Developer/Applications/Xcode.app")

  # Locate the "current Xcode folder" via xcode-select. See:
  # man xcode-select
  def folder
    @folder ||= `xcode-select -print-path 2>/dev/null`.strip
  end

  # Xcode 4.3 tools hang if "/" is set
  def bad_xcode_select_path?
    folder == "/"
  end

  def latest_version
    case MacOS.version
      when 10.5 then "3.1.4"
      when 10.6 then "3.2.6"
    else
      if MacOS.version >= 10.7
        "4.4.1"
      else
        raise "Mac OS X `#{MacOS.version}' is invalid"
      end
    end
  end

  def prefix
    @prefix ||= begin
      path = Pathname.new folder
      if path.absolute? and (path/'usr/bin/make').executable?
        path
      elsif File.executable? '/Developer/usr/bin/make'
        # we do this to support cowboys who insist on installing
        # only a subset of Xcode
        Pathname.new '/Developer'
      elsif (V4_BUNDLE_PATH/'Contents/Developer/usr/bin/make').executable?
        # fallback for broken Xcode 4.3 installs
        V4_BUNDLE_PATH/'Contents/Developer'
      else
        # Ask Spotlight where Xcode is. If the user didn't install the
        # helper tools and installed Xcode in a non-conventional place, this
        # is our only option. See: http://superuser.com/questions/390757
        path = MacOS.app_with_bundle_id(V4_BUNDLE_ID) ||
          MacOS.app_with_bundle_id(V3_BUNDLE_ID)

        unless path.nil?
          path += "Contents/Developer"
          path if (path/'usr/bin/make').executable?
        end
      end
    end
  end

  def installed?
    # Telling us whether the Xcode.app is installed or not.
    @installed ||= V4_BUNDLE_PATH.exist? ||
      V3_BUNDLE_PATH.exist? ||
      MacOS.app_with_bundle_id(V4_BUNDLE_ID) ||
      MacOS.app_with_bundle_id(V3_BUNDLE_ID) ||
      false
  end

  def version
    # may return a version string
    # that is guessed based on the compiler, so do not
    # use it in order to check if Xcode is installed.
    @version ||= uncached_version
  end

  def uncached_version
    # This is a separate function as you can't cache the value out of a block
    # if return is used in the middle, which we do many times in here.

    return "0" unless MACOS

    # this shortcut makes version work for people who don't realise you
    # need to install the CLI tools
    xcode43build = V4_BUNDLE_PATH/'Contents/Developer/usr/bin/xcodebuild'
    if xcode43build.file?
      `#{xcode43build} -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
      return $1 if $1
    end

    # Xcode 4.3 xc* tools hang indefinately if xcode-select path is set thus
    raise if bad_xcode_select_path?

    raise unless which "xcodebuild"
    `xcodebuild -version 2>/dev/null` =~ /Xcode (\d(\.\d)*)/
    raise if $1.nil? or not $?.success?
    $1
  rescue
    # For people who's xcode-select is unset, or who have installed
    # xcode-gcc-installer or whatever other combinations we can try and
    # supprt. See https://github.com/mxcl/homebrew/wiki/Xcode
    case MacOS.llvm_build_version.to_i
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
      case (MacOS.clang_version.to_f * 10).to_i
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

  def provides_autotools?
    version.to_f < 4.3
  end

  def provides_gcc?
    version.to_f < 4.3
  end
end

module MacOS::CLT extend self
  STANDALONE_PKG_ID = "com.apple.pkg.DeveloperToolsCLILeo"
  FROM_XCODE_PKG_ID = "com.apple.pkg.DeveloperToolsCLI"

  # This is true ift he standard UNIX tools are present under /usr. For
  # Xcode < 4.3, this is the standard location. Otherwise, it means that
  # the user has installed the "Command Line Tools for Xcode" package.
  def installed?
    MacOS.dev_tools_path == Pathname.new("/usr/bin")
  end

  def latest_version?
    `/usr/bin/clang -v` =~ %r{tags/Apple/clang-(\d+).(\d+).(\d+)}
    $1 >= 421 and $3 >= 57
  end

  def version
    # Version string (a pretty damn long one) of the CLT package.
    # Note, that different ways to install the CLTs lead to different
    # version numbers.
    @version ||= begin
      standalone = MacOS.pkgutil_info(STANDALONE_PKG_ID)
      from_xcode = MacOS.pkgutil_info(FROM_XCODE_PKG_ID)

      if not standalone.empty?
        standalone =~ /version: (.*)$/
        $1
      elsif not from_xcode.empty?
        from_xcode =~ /version: (.*)$/
        $1
      else
        nil
      end
    end
  end
end
