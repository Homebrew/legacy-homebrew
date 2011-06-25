require 'formula'

class Freealut < Formula
  url 'http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0.tar.gz'
  homepage 'http://connect.creativelabs.com/openal/Documentation/The%20OpenAL%20Utility%20Toolkit.htm'
  md5 'e089b28a0267faabdb6c079ee173664a'

  # Adds the OpenAL frameworks to the library list so linking succeeds
  def patches; DATA; end

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
