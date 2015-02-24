require "formula"

class FreeradiusServer < Formula
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.6.tar.gz"
  sha1 "25b0a057b1fffad5a030946e8af0c6170e5cdf46"
  revision 1

  devel do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.5.tar.bz2"
    sha1 "53432d83618f0719f8cab5957567fc173959f6e7"
    depends_on "talloc" => :build
  end

  bottle do
    sha1 "3a583d46e2c12badc7addf99fa1db83a8d5315b4" => :yosemite
    sha1 "ee905079281616a48339201938d11fe525d8b23f" => :mavericks
    sha1 "2e8de634e8fcf37a2a4d969d33371281667e5d2d" => :mountain_lion
  end

  depends_on "openssl"

  # libtool is glibtool on OS X
  stable do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    patch :DATA
  end

  def install
    openssl = Formula["openssl"]

    ENV.deparallelize

    args = [
      "--prefix=#{prefix}",
      "--sbindir=#{bin}",
      "--localstatedir=#{var}",
      "--with-openssl-includes=#{openssl.opt_include}",
      "--with-openssl-libraries=#{openssl.opt_lib}",
    ]

    if build.stable?
      args << "--with-system-libtool"
      args << "--with-system-libltdl"
      inreplace "autogen.sh", "libtool", "glibtool"
      system "./autogen.sh"
    end

    if build.devel?
      talloc = Formula["talloc"]
      args << "--with-talloc-lib-dir=#{talloc.opt_lib}"
      args << "--with-talloc-include-dir=#{talloc.opt_include}"
    end

    system "./configure", *args
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
