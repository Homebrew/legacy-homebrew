require 'formula'

class Pkcs11_220 < Formula
  # RSA PKCS #11 Cryptographic Token Interface (Cryptoki)
  # source reference:
  #   ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/
  #
  url 'ftp://ftp.archlinux.org/other/tc/pkcs-2.20.tar.gz'
  sha256 'd2bf64094eec48b4695a15d91c05fe4469485a5cc6b0efc0ee75a20c095bd40d'
end

class Truecrypt < Formula
  homepage 'http://truecrypt.org/'
  url 'http://connie.slackware.com/~alien/slackbuilds/truecrypt/build/truecrypt-7.1a-source.tar.gz'
  sha256 'e6214e911d0bbededba274a2f8f8d7b3f6f6951e20f1c3a598fc7a23af81c8dc'

  depends_on 'pkg-config' => :build
  depends_on 'nasm' => :build
  depends_on 'wxmac'
  depends_on 'fuse4x'

  # NOTE building
  # if you receive errors regarding 'wxString::wxString', make sure wxmac has
  # been compiled with --enable-std_string to enable
  #   "use standard C++ string classes"
  #
  # each patch commented separately with "[brew-truecrypt]"
  #
  def patches; DATA; end

  def install
    Pkcs11_220.new.brew { include.install Dir['*'] }
    ENV['PKCS11_INC'] = include

    inreplace 'Makefile' do |s|
      s.gsub! 'export CC ?= gcc', "export CC := #{ENV.cc}"
      s.gsub! 'export CXX ?= g++', "export CXX := #{ENV.cxx}"
      s.gsub! 'export APPNAME := truecrypt', "export APPNAME := $(BREW_TC_APPNAME)"

      # suppress linker warning:
      #   ld: warning: PIE disabled. Absolute addressing (perhaps -mdynamic-no-pic)
      #   not allowed in code signed PIE, but used in aes_encrypt.1 from
      #   [..]/Volume/Volume.a(Aes_x86.o). To fix this warning, don't compile with
      #   -mdynamic-no-pic or link with -Wl,-no_pie
      #
      s.gsub! 'export LFLAGS :=', 'export LFLAGS := -Wl,-no_pie'
    end

    mkdir_p 'toinstall'
    tc_nogui
    system 'make clean' # cruft
    tc_gui

    mv 'License.txt', 'LICENSE'
    mv 'Readme.txt', 'README'

    bin.install 'toinstall/truecrypt'
    prefix.install 'toinstall/TrueCrypt.app'
  end

  def tc_nogui
    ENV['BREW_TC_APPNAME'] = 'truecrypt'
    system 'make', 'NOGUI=1'
    mv 'Main/truecrypt', 'toinstall'
  end

  def tc_gui
    # camelcase Contents/MacOS/TrueCrypt in .app
    ENV['BREW_TC_APPNAME'] = 'TrueCrypt'
    system 'make'
    mv 'Main/TrueCrypt.app', 'toinstall'
  end

  def caveats; <<-EOS.undent
    1) command-line application 'truecrypt' installed to #{bin}

    2) 'TrueCrypt.app' GUI built


    TrueCrypt.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/TrueCrypt.app /Applications
    EOS
  end

  def test
    system "#{bin}/truecrypt --test"
  end
end

__END__

---
 Makefile |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index 265bb6f..b38ee00 100644
--- a/Makefile
+++ b/Makefile
@@ -171,15 +171,7 @@ endif
 ifeq "$(shell uname -s)" "Darwin"

 	PLATFORM := MacOSX
-	APPNAME := TrueCrypt
-
-	TC_OSX_SDK ?= /Developer/SDKs/MacOSX10.4u.sdk
-	CC := gcc-4.0
-	CXX := g++-4.0
-
-	C_CXX_FLAGS += -DTC_UNIX -DTC_BSD -DTC_MACOSX -mmacosx-version-min=10.4 -isysroot $(TC_OSX_SDK)
-	LFLAGS += -mmacosx-version-min=10.4 -Wl,-syslibroot $(TC_OSX_SDK)
-	WX_CONFIGURE_FLAGS += --with-macosx-version-min=10.4 --with-macosx-sdk=$(TC_OSX_SDK)
+	C_CXX_FLAGS += -DTC_UNIX -DTC_BSD -DTC_MACOSX

 	ifeq "$(CPU_ARCH)" "x64"
 		CPU_ARCH = x86
@@ -188,25 +180,18 @@ ifeq "$(shell uname -s)" "Darwin"
 	ASM_OBJ_FORMAT = macho
 	ASFLAGS += --prefix _

-	ifeq "$(TC_BUILD_CONFIG)" "Release"

 		export DISABLE_PRECOMPILED_HEADERS := 1

 		S := $(C_CXX_FLAGS)
 		C_CXX_FLAGS = $(subst -MMD,,$(S))

-		C_CXX_FLAGS += -gfull -arch i386 -arch ppc
-		LFLAGS += -Wl,-dead_strip -arch i386 -arch ppc
+		C_CXX_FLAGS += -gfull -arch i386
+		LFLAGS += -Wl,-dead_strip -arch i386

-		WX_CONFIGURE_FLAGS += --enable-universal_binary
 		WXCONFIG_CFLAGS += -gfull
 		WXCONFIG_CXXFLAGS += -gfull
-
-	else
-
-		WX_CONFIGURE_FLAGS += --disable-universal_binary
-
-	endif
+# [brew-truecrypt] disable PPC support, only build for Leopard 10.5+, don't override APPNAME or complier

 endif

--
1.7.9


---
 Core/Unix/MacOSX/CoreMacOSX.cpp |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/Core/Unix/MacOSX/CoreMacOSX.cpp b/Core/Unix/MacOSX/CoreMacOSX.cpp
index b7aa08c..882009d 100644
--- a/Core/Unix/MacOSX/CoreMacOSX.cpp
+++ b/Core/Unix/MacOSX/CoreMacOSX.cpp
@@ -108,22 +108,8 @@ namespace TrueCrypt

 	void CoreMacOSX::MountAuxVolumeImage (const DirectoryPath &auxMountPoint, const MountOptions &options) const
 	{
-		// Check FUSE version
-		char fuseVersionString[MAXHOSTNAMELEN + 1] = { 0 };
-		size_t fuseVersionStringLength = MAXHOSTNAMELEN;
-
-		if (sysctlbyname ("macfuse.version.number", fuseVersionString, &fuseVersionStringLength, NULL, 0) != 0)
-			throw HigherFuseVersionRequired (SRC_POS);
-
-		vector <string> fuseVersion = StringConverter::Split (string (fuseVersionString), ".");
-		if (fuseVersion.size() < 2)
-			throw HigherFuseVersionRequired (SRC_POS);
-
-		uint32 fuseVersionMajor = StringConverter::ToUInt32 (fuseVersion[0]);
-		uint32 fuseVersionMinor = StringConverter::ToUInt32 (fuseVersion[1]);
-
-		if (fuseVersionMajor < 1 || (fuseVersionMajor == 1 && fuseVersionMinor < 3))
-			throw HigherFuseVersionRequired (SRC_POS);
+// [brew-truecrypt] prevent "Error: TrueCrypt requires MacFUSE 1.3 or later."
+// [brew-truecrypt] since we're using fuse4x

 		// Mount volume image
 		string volImage = string (auxMountPoint) + FuseService::GetVolumeImagePath();
--
1.7.9


---
 Driver/Fuse/FuseService.cpp |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/Driver/Fuse/FuseService.cpp b/Driver/Fuse/FuseService.cpp
index fda56e0..4465a57 100644
--- a/Driver/Fuse/FuseService.cpp
+++ b/Driver/Fuse/FuseService.cpp
@@ -424,10 +424,7 @@ namespace TrueCrypt
 		args.push_back (fuseMountPoint);

 #ifdef TC_MACOSX
-		args.push_back ("-o");
-		args.push_back ("noping_diskarb");
-		args.push_back ("-o");
-		args.push_back ("nobrowse");
+// [brew-truecrypt] noping_diskarb and nobrowse not supported by fuse4x

 		if (getuid() == 0 || geteuid() == 0)
 #endif
--
1.7.9


---
 Main/Main.make |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Main/Main.make b/Main/Main.make
index 565ed40..a2ac305 100644
--- a/Main/Main.make
+++ b/Main/Main.make
@@ -76,7 +76,24 @@ CXXFLAGS += -I$(BASE_DIR)/Main
 #------ wxWidgets configuration ------

 ifdef TC_NO_GUI
-WX_CONFIG_LIBS := base
+WX_CONFIG_LIBS := core,base
+# [brew-truecrypt] prevent error:
+# [brew-truecrypt]
+# [brew-truecrypt]   "wxApp::MacPrintFile(wxString const&)", referenced from:
+# [brew-truecrypt]       vtable for TrueCrypt::TextUserInterfacein TextUserInterface.o
+# [brew-truecrypt]       vtable for TrueCrypt::UserInterfacein UserInterface.o
+# [brew-truecrypt]
+# [brew-truecrypt] Undefined symbols for architecture i386:
+# [brew-truecrypt]   "wxAppBase::GetLayoutDirection() const", referenced from:
+# [brew-truecrypt]       vtable for TrueCrypt::TextUserInterfacein TextUserInterface.o
+# [brew-truecrypt] [...]
+# [brew-truecrypt]   "wxApp::MacHandleUnhandledEvent(void*)", referenced from:
+# [brew-truecrypt]       vtable for TrueCrypt::TextUserInterfacein TextUserInterface.o
+# [brew-truecrypt]       vtable for TrueCrypt::UserInterfacein UserInterface.o
+# [brew-truecrypt] ld: symbol(s) not found for architecture i386
+# [brew-truecrypt] collect2: ld returned 1 exit status
+# [brew-truecrypt] make[1]: *** [TrueCrypt] Error 1
+# [brew-truecrypt] make: *** [all] Error 2
 else
 WX_CONFIG_LIBS := adv,core,base
 endif
--
1.7.9


---
 Main/FatalErrorHandler.cpp |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Main/FatalErrorHandler.cpp b/Main/FatalErrorHandler.cpp
index d84a717..060235e 100644
--- a/Main/FatalErrorHandler.cpp
+++ b/Main/FatalErrorHandler.cpp
@@ -23,7 +23,7 @@
 #	ifdef __ppc__
 #		include <ppc/ucontext.h>
 #	else
-#		include <i386/ucontext.h>
+#		include <sys/ucontext.h>
 #	endif
 #elif defined (TC_BSD)
 #	include <ucontext.h>
@@ -56,10 +56,11 @@ namespace TrueCrypt
 #elif defined (TC_MACOSX)
 #	ifdef __ppc__
 		faultingInstructionAddress = context->uc_mcontext->ss.srr0;
-#	elif defined (__x86_64__)
-		faultingInstructionAddress = context->uc_mcontext->ss.rip;
+		faultingInstructionAddress = context->uc_mcontext->__ss.__rip;
 #	else
-		faultingInstructionAddress = context->uc_mcontext->ss.eip;
+		faultingInstructionAddress = context->uc_mcontext->__ss.__eip;
+// [brew-truecrypt] support Leopard 10.5+
+// [brew-truecrypt] https://developer.apple.com/library/mac/#releasenotes/Darwin/RN-Unix03Conformance/_index.html
 #	endif

 #endif
--
1.7.9

