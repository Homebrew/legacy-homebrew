require 'formula'

class Yacas < Formula
  homepage 'http://yacas.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/yacas/yacas-source/1.3/yacas-1.3.6.tar.gz'
  sha1 'ee40d2156d54f08f8bb544edb5093259512d304b'

  option "with-server", "Build the network server version"

  # Patch to configure, src/Makefile.am and src/Makefile.in
  # install-sh -c -d doesn't work with directory name with trailing '/' => configure
  # OS/X's echo doesn't support '-e' option => Makefile.am, Makefile.in
  patch :p1, :DATA

  def install
    args = [ "--disable-silent-rules",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}"
    ]

    args << "--enable-server" if build.with? "server"

    system "./configure", *args
    system "make", "install"
    system "make", "test"
  end
end

__END__
--- yacas-1.3.6.orig/configure	2014-11-26 05:46:21.000000000 +0900
+++ yacas-1.3.6/configure	2014-12-30 17:02:39.000000000 +0900
@@ -16939,7 +16939,7 @@
 if test -n "$with_html_dir" ; then
 	htmldir=$with_html_dir
 else
-	htmldir=${datadir}/yacas/documentation/
+	htmldir=${datadir}/yacas/documentation
 fi
 
 
diff -ur yacas-1.3.6.orig/src/Makefile.am yacas-1.3.6/src/Makefile.am
--- yacas-1.3.6.orig/src/Makefile.am	2014-11-26 00:33:54.000000000 +0900
+++ yacas-1.3.6/src/Makefile.am	2014-12-30 15:26:56.000000000 +0900
@@ -104,7 +104,7 @@
 
 $(builddir)/../include/yacas/yacas_version.h: ../config.h
 	mkdir -p $(builddir)/../include/yacas
-	echo -e "#ifndef YACAS_VERSION_H\n#define YACAS_VERSION \"$(VERSION)\"\n#endif" > $(builddir)/../include/yacas/yacas_version.h
+	echo "#ifndef YACAS_VERSION_H\n#define YACAS_VERSION \"$(VERSION)\"\n#endif" > $(builddir)/../include/yacas/yacas_version.h
 
 distclean-local:
 	-rm -f $(builddir)/../include/yacas/yacas_version.h
diff -ur yacas-1.3.6.orig/src/Makefile.in yacas-1.3.6/src/Makefile.in
--- yacas-1.3.6.orig/src/Makefile.in	2014-12-30 14:56:18.000000000 +0900
+++ yacas-1.3.6/src/Makefile.in	2014-12-30 15:26:56.000000000 +0900
@@ -890,7 +890,7 @@
 
 $(builddir)/../include/yacas/yacas_version.h: ../config.h
 	mkdir -p $(builddir)/../include/yacas
-	echo -e "#ifndef YACAS_VERSION_H\n#define YACAS_VERSION \"$(VERSION)\"\n#endif" > $(builddir)/../include/yacas/yacas_version.h
+	echo "#ifndef YACAS_VERSION_H\n#define YACAS_VERSION \"$(VERSION)\"\n#endif" > $(builddir)/../include/yacas/yacas_version.h
 
 distclean-local:
 	-rm -f $(builddir)/../include/yacas/yacas_version.h
