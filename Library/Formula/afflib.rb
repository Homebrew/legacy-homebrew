class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.6.tar.gz"
  sha256 "494b040f2d53448390d4fa1ad3b9236b0bb8f7d3be39e6287806034647e97a06"

  bottle do
    cellar :any
    revision 1
    sha256 "21d20fcfdbd03d0a933f931794fc95c7c7153ca6318b5ad29b5469918fdea538" => :el_capitan
    sha1 "ffa18bea26fe2bd43b75c4260e9daee1c295d7bd" => :yosemite
    sha1 "21a44d9b557104bc4d15418e96e75d2e296d46e5" => :mavericks
    sha1 "1f80ffa8d2b263ed7e2116613dfd2af50d000b82" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "expat" => :optional
  depends_on :osxfuse => :optional
  depends_on "openssl"

  # This patch fixes a bug reported upstream over there
  # https://github.com/simsong/AFFLIBv3/issues/4
  patch :DATA

  def install
    system "./bootstrap.sh"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if build.with? "osxfuse"
      ENV["CPPFLAGS"] = "-I#{Formula["osxfuse"].include}/osxfuse"
      args << "--enable-fuse"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end

__END__
diff --git a/bootstrap.sh b/bootstrap.sh
index 3a7af59..7510933 100755
--- a/bootstrap.sh
+++ b/bootstrap.sh
@@ -6,7 +6,7 @@
 echo Bootstrap script to create configure script using autoconf
 echo
 # use the installed ones first, not matter what the path says.
-export PATH=/usr/bin:/usr/sbin:/bin:$PATH
+#export PATH=/usr/bin:/usr/sbin:/bin:$PATH
 touch NEWS README AUTHORS ChangeLog stamp-h
 aclocal
 LIBTOOLIZE=glibtoolize
diff --git a/configure.ac b/configure.ac
index 940353b..c530f2e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -241,10 +241,6 @@ AC_ARG_ENABLE(fuse,
 if test "x${enable_fuse}" = "xyes" ; then
   AC_MSG_NOTICE([FUSE requested])
   CPPFLAGS="-D_FILE_OFFSET_BITS=64 -DFUSE_USE_VERSION=26 $CPPFLAGS"
-  if test `uname -s` = Darwin ; then
-    AC_MSG_NOTICE([FUSE IS NOT SUPPORTED ON MACOS])
-    enable_fuse=no
-  fi
   AC_CHECK_HEADER([fuse.h],,
     AC_MSG_NOTICE([fuse.h not found; Disabling FUSE support.])
     enable_fuse=no)
@@ -255,7 +251,7 @@ AFFUSE_BIN=
 if test "${enable_fuse}" = "yes"; then
   AC_DEFINE([USE_FUSE],1,[Use FUSE to mount AFF images])
   AFFUSE_BIN='affuse$(EXEEXT)'
-  FUSE_LIBS=-lfuse
+  FUSE_LIBS=-losxfuse
 fi
 AC_SUBST(AFFUSE_BIN)
 AM_PROG_CC_C_O			dnl for affuse
