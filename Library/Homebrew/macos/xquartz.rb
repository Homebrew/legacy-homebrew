module MacOS::XQuartz extend self
  FORGE_BUNDLE_ID = "org.macosforge.xquartz.X11"
  APPLE_BUNDLE_ID = "org.x.X11"

  # This returns the version number of XQuartz, not of the upstream X.org.
  # The X11.app distributed by Apple is also XQuartz, and therefore covered
  # by this method.
  def version
    path = MacOS.app_with_bundle_id(FORGE_BUNDLE_ID) || MacOS.app_with_bundle_id(APPLE_BUNDLE_ID)
    version = if not path.nil? and path.exist?
      `mdls -raw -name kMDItemVersion "#{path}" 2>/dev/null`.strip
    end
  end

  # This should really be private, but for compatibility reasons it must
  # remain public. New code should use MacOS::XQuartz.{bin,lib,include}
  # instead, as that accounts for Xcode-only systems.
  def prefix
    @prefix ||= if Pathname.new('/opt/X11/lib/libpng.dylib').exist?
      Pathname.new('/opt/X11')
    elsif Pathname.new('/usr/X11/lib/libpng.dylib').exist?
      Pathname.new('/usr/X11')
    end
  end

  def installed?
    not prefix.nil?
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
    prefix/'bin'
  end

  def include
    @include ||= if use_sdk?
      MacOS.sdk_path/'usr/X11/include'
    else
      prefix/'include'
    end
  end

  def lib
    @lib ||= if use_sdk?
      MacOS.sdk_path/'usr/X11/lib'
    else
      prefix/'lib'
    end
  end

  def share
    prefix/'share'
  end

  private

  def use_sdk?
    not (prefix.to_s == '/opt/X11' or MacOS::CLT.installed?)
  end
end
