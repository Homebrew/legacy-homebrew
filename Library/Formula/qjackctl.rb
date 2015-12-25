class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.1.tar.gz"
  sha256 "98024e1ea9f55ac16c290feda051d6494b2261e83f6a918f0fa583b509e2bfd1"
  head "http://git.code.sf.net/p/qjackctl/code", :using=>:git

  stable do
    # fixes compile error with getDeviceUIDFromID and combo box device selection is general
    # also fixes linking without X11
    #
    # patch is composed of
    # https://sourceforge.net/p/qjackctl/code/ci/ce7bbc6814da9be44b9320fbe20dd524516d525f
    # https://sourceforge.net/p/qjackctl/code/ci/1983c9c4ce3ef663e29e8d07addee1d6856664fd
    # https://sourceforge.net/p/qjackctl/code/ci/979f0a5afef3107288b17a508966ca5f27ce7069
    patch :DATA
  end

  bottle do
    sha256 "5eb11af861de629ba8afba7d75c71b02029817a69d2a6a2db15f13fb3bea9594" => :el_capitan
    sha256 "5cf871c347c52298c161c83443f12a825cd18ce8037286dcc9cd552ab3857e9e" => :yosemite
    sha256 "671c6d52aa37729c4471390673310fa90c68139dae697f1630552b3b2511d690" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "qt"
  depends_on "jack"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--enable-qt4",
                          "--disable-dbus",
                          "--disable-xunique",
                          "--prefix=#{prefix}"

    system "make", "install"
    prefix.install "#{bin}/qjackctl.app"
    bin.install_symlink "#{prefix}/qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match /QjackCtl: \d+\.\b+/, shell_output("qjackctl --version 2>&1", 1)
  end
end

__END__
From ce7bbc6814da9be44b9320fbe20dd524516d525f Mon Sep 17 00:00:00 2001
From: David <ottodavid@gmx.net>
Date: Sun, 22 Nov 2015 09:08:04 +0100
Subject: [PATCH] Fix compile without X11

https://sourceforge.net/p/qjackctl/code/ce7bbc6814da9be44b9320fbe20dd524516d525f

When compiling without X11 (--disable-xunique) linking against X11 is not required
and would lead to an error.

diff --git a/configure.ac b/configure.ac
index 86ac6bd..ac0e66a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -360,9 +360,6 @@ if test "x$ac_portaudio" = "xyes"; then
    fi
 fi

-# Some recent distros (eg. fedora, debian) require this.
-ac_libs="$ac_libs -lX11"
-
 AC_SUBST(ac_libs)


@@ -455,6 +452,10 @@ fi
 # Check for X11 unique/single instance.
 if test "x$ac_xunique" = "xyes"; then
    AC_DEFINE(CONFIG_XUNIQUE, 1, [Define if X11 unique/single instance is enabled.])
+
+  # Some recent distros (eg. fedora, debian) require this.
+  ac_libs="$ac_libs -lX11"
+
 fi

 # Check for debugging stack-trace.

From 1983c9c4ce3ef663e29e8d07addee1d6856664fd Mon Sep 17 00:00:00 2001
From: Matthias Kronlachner <m.kronlachner@gmail.com>
Date: Thu, 12 Nov 2015 06:51:22 +0100
Subject: [PATCH] switched entries in interfacecombobox to make it work for osx

https://sourceforge.net/p/qjackctl/code/ci/1983c9c4ce3ef663e29e8d07addee1d6856664fd

Need because without an human readable interface name is passed to jackd instead
of the internal UID

diff --git a/src/qjackctlInterfaceComboBox.cpp b/src/qjackctlInterfaceComboBox.cpp
index fccabc4..274c330 100644
--- a/src/qjackctlInterfaceComboBox.cpp
+++ b/src/qjackctlInterfaceComboBox.cpp
@@ -425,7 +425,7 @@ void qjackctlInterfaceComboBox::populateModel (void)
							// only show human readable name
							// humanreadable \t UID
							sSubName = QString(coreDeviceName);
-							addCard(sSubName, sName);
+							addCard(sName, sSubName);
							if (sCurName == sName || sCurName == sSubName)
								iCurCard = iCards;
							++iCards;

From 979f0a5afef3107288b17a508966ca5f27ce7069 Mon Sep 17 00:00:00 2001
From: rncbc <rncbc@t430.rncbc.lan>
Date: Tue, 3 Nov 2015 12:25:15 +0000
Subject: [PATCH] - Blind fix to a FTBFS on macosx/coreaudio platforms, a
 leftover   from the unified interface device selection combo-box inception,
 almost two years ago. (TESTING)

https://sourceforge.net/p/qjackctl/code/ci/979f0a5afef3107288b17a508966ca5f27ce7069

getDeviceUIDFromID is not defined anywhere (at least on El Capitan) so without this,
compilation will fail


diff --git a/src/qjackctlInterfaceComboBox.cpp b/src/qjackctlInterfaceComboBox.cpp
index b33a7d8..fccabc4 100644
--- a/src/qjackctlInterfaceComboBox.cpp
+++ b/src/qjackctlInterfaceComboBox.cpp
@@ -111,6 +111,25 @@ void qjackctlInterfaceComboBox::addCard (
 }


+#ifdef CONFIG_COREAUDIO
+
+// borrowed from jackpilot source
+static OSStatus getDeviceUIDFromID( AudioDeviceID id,
+	char *name, UInt32 nsize )
+{
+	UInt32 size = sizeof(CFStringRef);
+	CFStringRef UI;
+	OSStatus res = AudioDeviceGetProperty(id, 0, false,
+		kAudioDevicePropertyDeviceUID, &size, &UI);
+	if (res == noErr)
+		CFStringGetCString(UI,name,nsize,CFStringGetSystemEncoding());
+	CFRelease(UI);
+	return res;
+}
+
+#endif // CONFIG_COREAUDIO
+
+
 #ifdef CONFIG_PORTAUDIO

 #include <QApplication>
