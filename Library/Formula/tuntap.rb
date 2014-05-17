require "formula"

class Tuntap < Formula
  homepage "http://tuntaposx.sourceforge.net/"
  url "git://git.code.sf.net/p/tuntaposx/code", :tag => "release_20111101"
  head "git://git.code.sf.net/p/tuntaposx/code", :branch => "master"

  # Get Kernel.framework headers from the SDK
  patch :DATA

  def install
    ENV.j1 # to avoid race conditions (can't open: ../tuntap.o)

    cd "tuntap" do
      system "make", "CC=#{ENV.cc}", "CCP=#{ENV.cxx}"
      kext_prefix.install "tun.kext", "tap.kext"
      prefix.install "startup_item/tap", "startup_item/tun"
    end
  end

  def caveats; <<-EOS.undent
      In order for TUN/TAP network devices to work, the tun/tap kernel extensions
      must be installed by the root user:

        sudo cp -pR #{kext_prefix}/tap.kext /Library/Extensions/
        sudo cp -pR #{kext_prefix}/tun.kext /Library/Extensions/
        sudo chown -R root:wheel /Library/Extensions/tap.kext
        sudo chown -R root:wheel /Library/Extensions/tun.kext
        sudo touch /Library/Extensions/

      To load the extensions at startup, you have to install those scripts too:

        sudo cp -pR #{prefix}/tap /Library/StartupItems/
        sudo chown -R root:wheel /Library/StartupItems/tap
        sudo cp -pR #{prefix}/tun /Library/StartupItems/
        sudo chown -R root:wheel /Library/StartupItems/tun

      If upgrading from a previous version of tuntap, the old kernel extension
      will need to be unloaded before performing the steps listed above. First,
      check that no tunnel is being activated, disconnect them all and then unload
      the kernel extension:

        sudo kextunload -b foo.tun
        sudo kextunload -b foo.tap

    EOS
  end
end

__END__
diff --git a/tuntap/src/tap/Makefile b/tuntap/src/tap/Makefile
index d4d1158..1dfe294 100644
--- a/tuntap/src/tap/Makefile
+++ b/tuntap/src/tap/Makefile
@@ -19,7 +19,8 @@ BUNDLE_SIGNATURE = ????
 BUNDLE_PACKAGETYPE = KEXT
 BUNDLE_VERSION = $(TAP_KEXT_VERSION)
 
-INCLUDE = -I.. -I/System/Library/Frameworks/Kernel.framework/Headers
+SDKROOT = $(shell xcodebuild -version -sdk macosx Path 2>/dev/null)
+INCLUDE = -I.. -I$(SDKROOT)/System/Library/Frameworks/Kernel.framework/Headers
 CFLAGS = -Wall -mkernel -force_cpusubtype_ALL \
 	-fno-builtin -fno-stack-protector -arch i386 -arch x86_64 \
 	-DKERNEL -D__APPLE__ -DKERNEL_PRIVATE -DTUNTAP_VERSION=\"$(TUNTAP_VERSION)\" \
diff --git a/tuntap/src/tun/Makefile b/tuntap/src/tun/Makefile
index 9ca6794..c530f10 100644
--- a/tuntap/src/tun/Makefile
+++ b/tuntap/src/tun/Makefile
@@ -20,7 +20,8 @@ BUNDLE_SIGNATURE = ????
 BUNDLE_PACKAGETYPE = KEXT
 BUNDLE_VERSION = $(TUN_KEXT_VERSION)
 
-INCLUDE = -I.. -I/System/Library/Frameworks/Kernel.framework/Headers
+SDKROOT = $(shell xcodebuild -version -sdk macosx Path 2>/dev/null)
+INCLUDE = -I.. -I$(SDKROOT)/System/Library/Frameworks/Kernel.framework/Headers
 CFLAGS = -Wall -mkernel -force_cpusubtype_ALL \
 	-fno-builtin -fno-stack-protector -arch i386 -arch x86_64 \
 	-DKERNEL -D__APPLE__ -DKERNEL_PRIVATE -DTUNTAP_VERSION=\"$(TUNTAP_VERSION)\" \
