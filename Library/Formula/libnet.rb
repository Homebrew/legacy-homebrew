require 'formula'

class Libnet < Formula
  homepage 'https://github.com/sam-github/libnet'
  url 'http://sourceforge.net/projects/libnet-dev/files/libnet-1.1.6.tar.gz'
  sha1 'dffff71c325584fdcf99b80567b60f8ad985e34c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
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
 
