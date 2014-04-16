require 'formula'

class FreeradiusServer < Formula
  homepage 'http://freeradius.org/'
  url 'ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.2.tar.gz'
  sha1 '6aaa14169c20f257dcd5dcc61da0d0f985e9b5cc'

  # Requires newer autotools on all platforms
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  # libtool is glibtool on OS X
  patch :DATA

  def install
    ENV.deparallelize

    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--with-system-libtool",
                          "--with-system-libltdl"
    system "make"
    system "make install"
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
