require 'formula'

class UpnpRouterControl < Formula
  homepage 'https://launchpad.net/upnp-router-control'
  url 'https://launchpad.net/upnp-router-control/trunk/0.2/+download/upnp-router-control-0.2.tar.gz'
  sha1 '4d6b22430f784260fccb2f70c27d0a428b9a753a'

  head do
    url 'bzr://lp:upnp-router-control'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'gupnp'
  depends_on 'gssdp'
  depends_on 'curl' => :optional
  depends_on :x11

  # Per Debian, patch to compile against newer gupnp
  patch :DATA

  def install
    system "./autogen.sh" if build.head?

    # Recent gupnp pc files don't export symbols from gssdp
    # Bug Ref: https://bugs.launchpad.net/upnp-router-control/+bug/1100236
    if not build.head?
      ENV.append_to_cflags %x[pkg-config --cflags gssdp-1.0].chomp
      ENV['LIBS'] = %x[pkg-config --libs gssdp-1.0].chomp
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
Description: Add -lm to LDADD to fix libm underlinkage.
Debian-Bug: http://bugs.debian.org/713706
Author: Barry deFreese <bdefreese@debian.org>
Index: upnp-router-control-0.2/src/Makefile.am
===================================================================
--- upnp-router-control-0.2.orig/src/Makefile.am	2010-10-14 18:02:51.000000000 -0400
+++ upnp-router-control-0.2/src/Makefile.am	2013-07-13 10:10:02.406318866 -0400
@@ -20,7 +20,7 @@
        urc-graph.c \
        urc-graph.h
 
-upnp_router_control_LDADD = @GTK_LIBS@ @INTLLIBS@ @GUPNP_LIBS@ @LIBCURL_LIBS@
+upnp_router_control_LDADD = @GTK_LIBS@ @INTLLIBS@ @GUPNP_LIBS@ @LIBCURL_LIBS@ -lm
 
 MAINTAINERCLEANFILES =				\
 	*~			      				\
Index: upnp-router-control-0.2/src/Makefile.in
===================================================================
--- upnp-router-control-0.2.orig/src/Makefile.in	2010-10-14 18:07:44.000000000 -0400
+++ upnp-router-control-0.2/src/Makefile.in	2013-07-13 10:10:41.238511424 -0400
@@ -213,7 +213,7 @@
        urc-graph.c \
        urc-graph.h
 
-upnp_router_control_LDADD = @GTK_LIBS@ @INTLLIBS@ @GUPNP_LIBS@ @LIBCURL_LIBS@
+upnp_router_control_LDADD = @GTK_LIBS@ @INTLLIBS@ @GUPNP_LIBS@ @LIBCURL_LIBS@ -lm
 MAINTAINERCLEANFILES = \
 	*~			      				\
 	Makefile.in
