require 'formula'

class Freealut < Formula
  homepage 'http://connect.creativelabs.com/openal/Documentation/The%20OpenAL%20Utility%20Toolkit.htm'
  url 'http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0.tar.gz'
  mirror 'http://ftp.de.debian.org/debian/pool/main/f/freealut/freealut_1.1.0.orig.tar.gz'
  sha1 'b2c04d2b5e0896b3164c01deda39f58933c8055f'

  # Adds the OpenAL frameworks to the library list so linking succeeds
  patch :DATA

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 2b26d6d..4001db1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,7 +83,8 @@ AC_DEFINE([ALUT_BUILD_LIBRARY], [1], [Define to 1 if you want to build the ALUT
 
 # Checks for libraries. (not perfect yet)
 AC_SEARCH_LIBS([pthread_self], [pthread])
-AC_SEARCH_LIBS([alGetError], [openal32 openal])
+# Use Mac OS X frameworks
+LIBS="$LIBS -framework IOKit -framework OpenAL"
 
 ################################################################################
 # Checks for header files.
