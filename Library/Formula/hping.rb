require 'formula'

class Hping < Formula
  homepage 'http://www.hping.org/'
  url 'http://www.hping.org/hping3-20051105.tar.gz'
  sha1 'e13d27e14e7f90c2148a9b00a480781732fd351e'
  version '3.20051105'

  patch :DATA

  patch :p0 do
    url "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-libpcap_stuff.c.diff"
    sha1 "f45eef54b327bafd65d7911ffca86ce1f4ea0c7f"
  end

  patch :p0 do
    url "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-ars.c.diff"
    sha1 "fb28fc544f6c57c5a16ff584703646a89d335f6c"
  end

  patch :p0 do
    url "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-sendip.c.diff"
    sha1 "6aad537b1afd33cd90d5926c718b3e8970b2eca5"
  end

  patch :p0 do
    url "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-Makefile.in.diff"
    sha1 "0d2b52623020c04b07cae3f512e917ad8d54ae03"
  end

  patch :p0 do
    url "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-bytesex.h.diff"
    sha1 "01e69fd8684a61568ac384bd62017bec6fed6ee5"
  end

  def install
    # Compile fails with tcl support; TCL on OS X is 32-bit only
    system "./configure", "--no-tcl"

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make", "CC=#{ENV.cc}",
                   "COMPILE_TIME=#{ENV.cflags}",
                   "INSTALL_PATH=#{prefix}",
                   "INSTALL_MANPATH=#{man}",
                   "install"
  end
end

__END__
diff --git a/gethostname.c b/gethostname.c
index 3d0ea58..a8a9699 100644
--- a/gethostname.c
+++ b/gethostname.c
@@ -18,8 +18,6 @@
 #include <arpa/inet.h>
 #include <string.h>
 
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 char *get_hostname(char* addr)
 {
 	static char answer[1024];
