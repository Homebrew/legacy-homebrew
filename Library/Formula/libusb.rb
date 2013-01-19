require 'formula'

class Libusb < Formula
  homepage 'http://www.libusb.org/'
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2'
  sha256 'e920eedc2d06b09606611c99ec7304413c6784cba6e33928e78243d323195f9b'

  head 'git://git.libusb.org/libusb.git'

  conflicts_with 'libusbx',
    :because => 'libusbx and libusb install the same binaries.'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end

  # The 'system "./autogen.sh" step fails. Tickets #159 and #161 address this.
  # "Automake-1.13 removed long obsolete AM_CONFIG_HEADER completely ..."
  def patches; build.head? ? DATA : []; end
end

__END__
diff --git a/configure.ac b/configure.ac
index 260d2f7..d127601 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,7 +31,7 @@ AM_MAINTAINER_MODE
 
 AC_CONFIG_SRCDIR([libusb/core.c])
 AC_CONFIG_MACRO_DIR([m4])
-AM_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])
 
 AC_PREREQ([2.50])
