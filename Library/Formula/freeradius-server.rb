require "formula"

class FreeradiusServer < Formula
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.5.tar.gz"
  sha1 "4d18ed8ff3fde4a29112ecc07f175b774ed5f702"
  depends_on "openssl"
  revision 1

  devel do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.4.tar.bz2"
    sha1 "baa58979672f6fc57ab4f16e947b85b9a6eee969"
    depends_on "talloc" => :build
  end

  bottle do
    revision 1
    sha1 "8d4ee7a2f614da03a1cabd3ec5214a70d0170319" => :mavericks
    sha1 "2d4a5a91820eead568781f256e5c4ad4b9b44afb" => :mountain_lion
    sha1 "b553c57efec7453296980809c417d090835522d8" => :lion
  end

  # libtool is glibtool on OS X
  stable do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    patch :DATA
  end

  def install
    openssl = Formula["openssl"]
    args = [ "--prefix=#{prefix}", "--sbindir=#{bin}",
             "--localstatedir=#{var}" ]
    ENV.deparallelize

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
    args << "--with-openssl-includes=#{openssl.opt_include}"
    args << "--with-openssl-libraries=#{openssl.opt_lib}"

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
