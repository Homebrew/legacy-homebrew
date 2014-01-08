require 'formula'

class Lrdf < Formula
  homepage 'https://github.com/swh/LRDF'
  url 'https://github.com/swh/LRDF/archive/0.5.0.zip'
  sha1 'c983c78f27ec2ddf1b699879ded840291aaba0c1'

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "raptor"

  # Fix for newer autotools
  def patches; DATA; end

  def install
    system "glibtoolize"
    system "aclocal", "-I", "m4"
    system "autoconf"
    system "automake", "-a", "-c"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -ur LRDF-0.5.0-o/configure.ac LRDF-0.5.0/configure.ac
--- LRDF-0.5.0-o/configure.ac	2013-03-16 16:52:58.000000000 -0400
+++ LRDF-0.5.0/configure.ac	2013-03-16 16:53:18.000000000 -0400
@@ -1,7 +1,7 @@
 # Process this file with autoconf to produce a configure script.
 AC_INIT(src/lrdf.c)
 AC_CONFIG_MACRO_DIR([m4])
-AM_CONFIG_HEADER(config.h)
+AC_CONFIG_HEADERS([config.h])
 AM_INIT_AUTOMAKE(liblrdf, 0.5.0)

 LRDF_LIBTOOL_VERSION=2:0:0
