require "formula"

class FreeradiusServer < Formula
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.5.tar.gz"
  sha1 "4d18ed8ff3fde4a29112ecc07f175b774ed5f702"
  revision 2

  devel do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.4.tar.bz2"
    sha1 "baa58979672f6fc57ab4f16e947b85b9a6eee969"
    depends_on "talloc" => :build
  end

  bottle do
    sha1 "588867d47d85bbbf558d8e4332227bc3d5f9eb79" => :mavericks
    sha1 "a5c11d2365f5ea91a7563d1090fa3f57761834a3" => :mountain_lion
    sha1 "5b061feeae193e2f1bf1e816fb7c49e85155bd71" => :lion
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
