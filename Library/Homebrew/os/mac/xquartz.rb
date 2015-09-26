module OS
  module Mac
    X11 = XQuartz = Module.new

    module XQuartz
      extend self

      FORGE_BUNDLE_ID = "org.macosforge.xquartz.X11"
      APPLE_BUNDLE_ID = "org.x.X11"
      FORGE_PKG_ID = "org.macosforge.xquartz.pkg"

      PKGINFO_VERSION_MAP = {
        "2.6.34" => "2.6.3",
        "2.7.4"  => "2.7.0",
        "2.7.14" => "2.7.1",
        "2.7.28" => "2.7.2",
        "2.7.32" => "2.7.3",
        "2.7.43" => "2.7.4",
        "2.7.50" => "2.7.5_rc1",
        "2.7.51" => "2.7.5_rc2",
        "2.7.52" => "2.7.5_rc3",
        "2.7.53" => "2.7.5_rc4",
        "2.7.54" => "2.7.5",
        "2.7.61" => "2.7.6",
        "2.7.73" => "2.7.7"
      }.freeze

      # This returns the version number of XQuartz, not of the upstream X.org.
      # The X11.app distributed by Apple is also XQuartz, and therefore covered
      # by this method.
      def version
        @version ||= detect_version
      end

      def detect_version
        if (path = bundle_path) && path.exist? && (version = version_from_mdls(path))
          version
        elsif prefix.to_s == "/usr/X11"
          guess_system_version
        else
          version_from_pkgutil
        end
      end

      # https://xquartz.macosforge.org/trac/wiki
      # https://xquartz.macosforge.org/trac/wiki/Releases
      def latest_version
        case MacOS.version
        when "10.5"
          "2.6.3"
        else
          "2.7.7"
        end
      end

      def bundle_path
        MacOS.app_with_bundle_id(FORGE_BUNDLE_ID, APPLE_BUNDLE_ID)
      end

      def version_from_mdls(path)
        version = Utils.popen_read(
          "/usr/bin/mdls", "-raw", "-nullMarker", "", "-name", "kMDItemVersion", path.to_s
        ).strip
        version unless version.empty?
      end

      # The XQuartz that Apple shipped in OS X through 10.7 does not have a
      # pkg-util entry, so if Spotlight indexing is disabled we must make an
      # educated guess as to what version is installed.
      def guess_system_version
        case MacOS.version
        when "10.5" then "2.1.6"
        when "10.6" then "2.3.6"
        when "10.7" then "2.6.3"
        else "dunno"
        end
      end

      # Upstream XQuartz *does* have a pkg-info entry, so if we can't get it
      # from mdls, we can try pkgutil. This is very slow.
      def version_from_pkgutil
        str = MacOS.pkgutil_info(FORGE_PKG_ID)[/version: (\d\.\d\.\d+)$/, 1]
        PKGINFO_VERSION_MAP.fetch(str, str)
      end

      def provided_by_apple?
        [FORGE_BUNDLE_ID, APPLE_BUNDLE_ID].find do |id|
          MacOS.app_with_bundle_id(id)
        end == APPLE_BUNDLE_ID
      end

      # This should really be private, but for compatibility reasons it must
      # remain public. New code should use MacOS::X11.bin, MacOS::X11.lib and
      # MacOS::X11.include instead, as that accounts for Xcode-only systems.
      def prefix
        @prefix ||= if Pathname.new("/opt/X11/lib/libpng.dylib").exist?
          Pathname.new("/opt/X11")
        elsif Pathname.new("/usr/X11/lib/libpng.dylib").exist?
          Pathname.new("/usr/X11")
        end
      end

      def installed?
        !version.nil? && !prefix.nil?
      end

      # If XQuartz and/or the CLT are installed, headers will be found under
      # /opt/X11/include or /usr/X11/include. For Xcode-only systems, they are
      # found in the SDK, so we use sdk_path for both the headers and libraries.
      # Confusingly, executables (e.g. config scripts) are only found under
      # /opt/X11/bin or /usr/X11/bin in all cases.
      def effective_prefix
        if provided_by_apple? && Xcode.without_clt?
          Pathname.new("#{OS::Mac.sdk_path}/usr/X11")
        else
          prefix
        end
      end

      def bin
        prefix/"bin"
      end

      def include
        effective_prefix/"include"
      end

      def lib
        effective_prefix/"lib"
      end

      def share
        prefix/"share"
      end
    end
  end
end
