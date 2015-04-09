class Osxfuse < Formula
  homepage "https://osxfuse.github.io/"
  url "https://github.com/osxfuse/osxfuse.git", :tag => "osxfuse-2.7.5"

  head "https://github.com/osxfuse/osxfuse.git", :branch => "osxfuse-2"

  bottle do
    sha1 "332ce64ede6db163578ef893be7cbd18e8014b9c" => :mavericks
    sha1 "58420e5c9cc687f5ddd6fb670ca25785f3f9468e" => :mountain_lion
  end

  depends_on :macos => :snow_leopard
  depends_on :xcode => :build

  # A fairly heinous hack to workaround our dependency resolution getting upset
  # See https://github.com/Homebrew/homebrew/issues/35073
  depends_on ConflictsWithBinaryOsxfuse => :build
  depends_on UnsignedKextRequirement => [ :cask => "osxfuse",
      :download => "http://sourceforge.net/projects/osxfuse/files/" ]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build

  conflicts_with "fuse4x", :because => "both install `fuse.pc`"

  # allow building with Xcode 6.3
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
index bf4b006..393e2eb 100755
--- a/build.sh
+++ b/build.sh
@@ -105,6 +105,9 @@ readonly M_XCODE61_COMPILER="com.apple.compilers.llvm.clang.1_0"
 declare M_XCODE62=""
 declare M_XCODE62_VERSION=6.2
 readonly M_XCODE62_COMPILER="com.apple.compilers.llvm.clang.1_0"
+declare M_XCODE63=""
+declare M_XCODE63_VERSION=6.3
+readonly M_XCODE63_COMPILER="com.apple.compilers.llvm.clang.1_0"
 
 declare M_ACTUAL_PLATFORM=""
 declare M_PLATFORMS=""
@@ -2569,6 +2572,14 @@ function m_handler()
                     M_XCODE62_VERSION=$m_xcode_version
                 fi
                 ;;
+            6.3*)
+                m_version_compare $M_XCODE63_VERSION $m_xcode_version
+                if [[ $? != 2 ]]
+                then
+                    M_XCODE63="$m_xcode_root"
+                    M_XCODE63_VERSION=$m_xcode_version
+                fi
+                ;;
             *)
                 m_log "skip unsupported Xcode version in '$m_xcode_root'."
                 ;;
@@ -2786,6 +2797,21 @@ function m_handler()
         M_SDK_1010_COMPILER="$M_XCODE62_COMPILER"
         m_platform_realistic_add "10.10"
     fi
+    if [[ -n "$M_XCODE63" ]]
+    then
+        m_xcode_latest="$M_XCODE63"
+
+        M_SDK_109="$M_XCODE63/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk"
+        M_SDK_109_XCODE="$M_XCODE63"
+        M_SDK_109_COMPILER="$M_XCODE63_COMPILER"
+        m_platform_realistic_add "10.9"
+        m_platform_add "10.10"
+
+        M_SDK_1010="$M_XCODE63/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk"
+        M_SDK_1010_XCODE="$M_XCODE63"
+        M_SDK_1010_COMPILER="$M_XCODE63_COMPILER"
+        m_platform_realistic_add "10.10"
+    fi
 
     m_read_input "$@"
 
