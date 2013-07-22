module MacOS::XQuartz extend self
  FORGE_BUNDLE_ID = "org.macosforge.xquartz.X11"
  APPLE_BUNDLE_ID = "org.x.X11"
  FORGE_PKG_ID = "org.macosforge.xquartz.pkg"

  # This returns the version number of XQuartz, not of the upstream X.org.
  # The X11.app distributed by Apple is also XQuartz, and therefore covered
  # by this method.
  def version
    @version ||= detect_version
  end

  def detect_version
    if (path = bundle_path) && path.exist?
      version_from_mdls(path)
    elsif prefix.to_s == "/usr/X11"
      guess_system_version
    else
      version_from_pkgutil
    end
  end

  def latest_version
    "2.7.4"
  end

  def bundle_path
    MacOS.app_with_bundle_id(FORGE_BUNDLE_ID) || MacOS.app_with_bundle_id(APPLE_BUNDLE_ID)
  end

  def version_from_mdls(path)
    `mdls -raw -name kMDItemVersion "#{path}" 2>/dev/null`.strip
  end

  # The XQuartz that Apple shipped in OS X through 10.7 does not have a
  # pkg-util entry, so if Spotlight indexing is disabled we must make an
  # educated guess as to what version is installed.
  def guess_system_version
    case MacOS.version
    when '10.5' then '2.1.6'
    when '10.6' then '2.3.6'
    when '10.7' then '2.6.3'
    else 'dunno'
    end
  end

  # Upstream XQuartz *does* have a pkg-info entry, so if we can't get it
  # from mdls, we can try pkgutil. This is very slow.
  # NOTE: this sacrifices correctness, as it returns an internal version
  # that may not always match the "user-facing" version string.
  def version_from_pkgutil
    MacOS.pkgutil_info(FORGE_PKG_ID)[/version: (\d\.\d\.\d).+$/, 1]
  end

  def provided_by_apple?
    [FORGE_BUNDLE_ID, APPLE_BUNDLE_ID].find do |id|
      MacOS.app_with_bundle_id(id)
    end == APPLE_BUNDLE_ID
  end

  # This should really be private, but for compatibility reasons it must
  # remain public. New code should use MacOS::X11.{bin,lib,include}
  # instead, as that accounts for Xcode-only systems.
  def prefix
    @prefix ||= if Pathname.new('/opt/X11/lib/libpng.dylib').exist?
      Pathname.new('/opt/X11')
    elsif Pathname.new('/usr/X11/lib/libpng.dylib').exist?
      Pathname.new('/usr/X11')
    end
  end

  def installed?
    !version.nil? && !prefix.nil?
  end
end

module MacOS::X11 extend self
  def prefix
    MacOS::XQuartz.prefix
  end

  def installed?
    MacOS::XQuartz.installed?
  end

  # If XQuartz and/or the CLT are installed, headers will be found under
  # /opt/X11/include or /usr/X11/include. For Xcode-only systems, they are
  # found in the SDK, so we use sdk_path for both the headers and libraries.
  # Confusingly, executables (e.g. config scripts) are only found under
  # /opt/X11/bin or /usr/X11/bin in all cases.
  def bin
    Pathname.new("#{prefix}/bin")
  end

  def include
    @include ||= if use_sdk?
      Pathname.new("#{MacOS.sdk_path}/usr/X11/include")
    else
      Pathname.new("#{prefix}/include")
    end
  end

  def lib
    @lib ||= if use_sdk?
      Pathname.new("#{MacOS.sdk_path}/usr/X11/lib")
    else
      Pathname.new("#{prefix}/lib")
    end
  end

  def share
    Pathname.new("#{prefix}/share")
  end

  private

  def use_sdk?
    not (prefix.to_s == '/opt/X11' or MacOS::CLT.installed?)
  end
end
