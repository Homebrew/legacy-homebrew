require 'formula'

class Libnet < Formula
  url "https://github.com/sam-github/libnet/tarball/libnet-1.1.4"
  md5 "0cb6c04063c1db37c91af08c76d25134"
  head 'https://github.com/sam-github/libnet.git'
  homepage 'https://github.com/sam-github/libnet'

  def install
    cd 'libnet'
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh"

    unless MacOS.leopard?
      cp "/usr/share/libtool/config/config.guess", "."
      cp "/usr/share/libtool/config/config.sub", "."
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    touch 'doc/man/man3/libnet.3'
    system "make install"
  end

  def patches
    # patches from macports to fix runtime problem on Intel
	DATA
  end
end

__END__
--- x/libnet/configure.in.org	2006-08-30 07:53:09.000000000 -0700
+++ x/libnet/configure.in	2006-08-30 07:54:01.000000000 -0700
@@ -158,6 +158,23 @@
 *darwin*)
     AC_DEFINE(HAVE_SOCKADDR_SA_LEN)
     LIBNET_CONFIG_DEFINES="-DHAVE_SOCKADDR_SA_LEN"
+
+dnl 
+dnl Check to see if x86
+dnl 
+
+    case "$target" in
+    i?86-*-*darwin*)
+        AC_DEFINE(LIBNET_BSDISH_OS)
+        AC_DEFINE(LIBNET_BSD_BYTE_SWAP)
+        LIBNET_CONFIG_DEFINES="$LIBNET_CONFIG_DEFINES -DLIBNET_BSDISH_OS -DLIBNET_BSD_BYTE_SWAP"
+        ;;
+
+    *)
+        ;;
+
+    esac
+
     ;;
 
 *solaris*)
 