class Freealut < Formula
  desc "Implementation of OpenAL's ALUT standard"
  homepage "https://github.com/vancegroup/freealut"
  url "http://connect.creativelabs.com/openal/Downloads/ALUT/freealut-1.1.0.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/f/freealut/freealut_1.1.0.orig.tar.gz"
  sha256 "60d1ea8779471bb851b89b49ce44eecb78e46265be1a6e9320a28b100c8df44f"

  bottle do
    cellar :any
    sha256 "301e3825367cee8b41747fae0b3495e94b09668d93980032f5fdb92d1c597b62" => :el_capitan
    sha256 "491e2736570843c5d42576563f7797f2f5c13fb3bb97ece3c9396e1fdb7e054a" => :yosemite
    sha256 "7438514f5d0b1cc9875fc0db4c4dbf48eb65049cc634c3115da4525a813f13d7" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Adds the OpenAL frameworks to the library list so linking succeeds
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
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
