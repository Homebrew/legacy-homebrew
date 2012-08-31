require 'formula'

class Disktype < Formula
  head 'cvs://:pserver:anonymous@disktype.cvs.sourceforge.net:/cvsroot/disktype:disktype'
  homepage 'http://disktype.sourceforge.net/'
  md5 '25a673f162b9c01cd565109202559489'

  # Fixes faulty Mac OS version checking
  def patches
    DATA
  end

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end
end

__END__
diff --git a/Makefile b/Makefile
index b91d771..20396c6 100644
--- a/Makefile
+++ b/Makefile
@@ -30,23 +30,6 @@ ifeq ($(NOSYS),)
   ifeq ($(system),Darwin)
     CPPFLAGS += -DUSE_MACOS_TYPE -DUSE_IOCTL_DARWIN
     LIBS     += -framework CoreServices
-    ifeq (/Developer/SDKs/MacOSX10.4u.sdk,$(wildcard /Developer/SDKs/MacOSX10.4u.sdk))
-      CPPFLAGS += -isysroot /Developer/SDKs/MacOSX10.4u.sdk
-      CFLAGS   += -arch i386 -arch ppc -mmacosx-version-min=10.4
-      LDFLAGS  += -arch i386 -arch ppc -mmacosx-version-min=10.4 -Wl,-syslibroot,/Developer/SDKs/MacOSX10.4u.sdk
-    else
-      ifeq (/Developer/SDKs/MacOSX10.5.sdk,$(wildcard /Developer/SDKs/MacOSX10.5.sdk))
-        CPPFLAGS += -isysroot /Developer/SDKs/MacOSX10.5.sdk
-        CFLAGS   += -arch i386 -arch ppc -mmacosx-version-min=10.5
-        LDFLAGS  += -arch i386 -arch ppc -mmacosx-version-min=10.5 -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk
-      else
-        ifeq (/Developer/SDKs/MacOSX10.6.sdk,$(wildcard /Developer/SDKs/MacOSX10.6.sdk))
-          CPPFLAGS += -isysroot /Developer/SDKs/MacOSX10.6.sdk
-          CFLAGS   += -arch i386 -arch ppc -mmacosx-version-min=10.6
-          LDFLAGS  += -arch i386 -arch ppc -mmacosx-version-min=10.6 -Wl,-syslibroot,/Developer/SDKs/MacOSX10.6.sdk
-        endif
-      endif
-    endif
   endif
   ifeq ($(system),AmigaOS)
     CC       += -noixemul
