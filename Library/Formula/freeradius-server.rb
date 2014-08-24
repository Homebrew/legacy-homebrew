require "formula"

class FreeradiusServer < Formula
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.5.tar.gz"
  sha1 "4d18ed8ff3fde4a29112ecc07f175b774ed5f702"
  revision 1

  bottle do
    sha1 "1b09524c30ec6cbc8ec20693c4dd2775496005fa" => :mavericks
    sha1 "ee83b996d5a78b1100438c91e5757d046212191f" => :mountain_lion
    sha1 "e5d9d29b3beb24254b6570cbb1dc3c6c13496892" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  # libtool is glibtool on OS X
  patch :DATA

  def install
    openssl = Formula["openssl"]

    ENV.deparallelize
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}",
                          "--with-system-libtool",
                          "--with-system-libltdl",
                          "--with-openssl-includes=#{openssl.opt_include}",
                          "--with-openssl-libraries=#{openssl.opt_lib}"
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end
end

__END__
diff --git a/configure.in b/configure.in
index 62b0de8..97e0243 100644
--- a/configure.in
+++ b/configure.in
@@ -101,7 +101,7 @@ AC_SUBST(LTDL_SUBDIRS)
 dnl use system-wide libtool, if it exists
 AC_ARG_WITH(system-libtool,
 [  --with-system-libtool   Use the libtool installed in your system (default=use our own)],
-[ AC_PATH_PROG(LIBTOOL, libtool,,$PATH:/usr/local/bin) AC_LIBTOOL_DLOPEN
+[ AC_PATH_PROG(LIBTOOL, glibtool,,$PATH:/usr/local/bin) AC_LIBTOOL_DLOPEN
  AC_PROG_LIBTOOL],
 [
   LIBTOOL="`pwd`/libtool"
