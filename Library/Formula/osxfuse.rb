require "formula"

class Osxfuse < Formula
  homepage "http://osxfuse.github.io"
  url "https://github.com/osxfuse/osxfuse.git", :tag => "osxfuse-2.7.0"

  head "https://github.com/osxfuse/osxfuse.git", :branch => "osxfuse-2"

  bottle do
    sha1 "e96e12d2fe72a2a85f80b9c9b640229f269cdb82" => :mavericks
    sha1 "f3a10fed4401867107fcee6850f03301f1698f49" => :mountain_lion
    sha1 "a7b6d7d22f08d64efab35917c7ee2338a5487b22" => :lion
  end

  depends_on :macos => :snow_leopard
  depends_on :xcode => :build
  depends_on ConflictsWithBinaryOsxfuse
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build

  conflicts_with "fuse4x", :because => "both install `fuse.pc`"

  # Fix for Xcode 6.1 beta: https://github.com/osxfuse/osxfuse/pull/159
  patch :DATA

  def install
    # Do not override Xcode build settings
    ENV.remove_cc_etc

    system "./build.sh", "-t", "homebrew", "-f", prefix
  end

  def caveats; <<-EOS.undent
    If upgrading from a previous version of osxfuse, the previous kernel extension
    will need to be unloaded before installing the new version. First, check that
    no FUSE-based file systems are running:

      mount -t osxfusefs

    Unmount all FUSE file systems and then unload the kernel extension:

      sudo kextunload -b com.github.osxfuse.filesystems.osxfusefs

    The new osxfuse file system bundle needs to be installed by the root user:

      sudo /bin/cp -RfX #{opt_prefix}/Library/Filesystems/osxfusefs.fs /Library/Filesystems/
      sudo chmod +s /Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs
    EOS
  end
end

__END__
diff --git a/build.sh b/build.sh
index 53724f2..f3275fb 100755
--- a/build.sh
+++ b/build.sh
@@ -2387,7 +2387,7 @@ function m_handler()
                     M_XCODE51_VERSION=$m_xcode_version
                 fi
                 ;;
-            6.0*)
+            6.0*|6.1*)
                 m_version_compare $M_XCODE60_VERSION $m_xcode_version
                 if [[ $? != 2 ]]
                 then
