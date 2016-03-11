class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.7.tar.gz"
  sha256 "049acb8b430fc354de0ae8b8c2043c221a213bcb17259eb099e1d5523a9697bf"

  bottle do
    cellar :any
    sha256 "b31a73db6339ce92a10aac22aa087fcbf92c783494e09400b698c7ac5b994345" => :el_capitan
    sha256 "dc89843c96eafc42c84834a5490169f59facc1d33036139d97009c03ae55592c" => :yosemite
    sha256 "0293b47792615b7b36e06d55f50d3565d4e6a251b1dad09ad3f7a673f1b856f2" => :mavericks
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
