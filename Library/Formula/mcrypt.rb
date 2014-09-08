require "formula"

class Mcrypt < Formula
  homepage "http://mcrypt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz"
  sha1 "8ae0e866714fbbb96a0a6fa9f099089dc93f1d86"

  bottle do
    sha1 "9afdc1c3fdbf8f9801301fb959c0192b99072fc7" => :mavericks
    sha1 "71c4c177e18d8ee3be7a1f5556c40ec5d2ba5a4d" => :mountain_lion
    sha1 "ac147e3524ce21a9d57c0fa84e3c8e2db26321e1" => :lion
  end

  depends_on "mhash"

  resource "libmcrypt" do
    url "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
    sha1 "9a426532e9087dd7737aabccff8b91abf9151a7a"
  end

  option :universal

  # Patch to correct inclusion of malloc function on OSX.
  # Upstream: https://sourceforge.net/p/mcrypt/patches/14/
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    resource("libmcrypt").stage do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libmcrypt-prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/src/rfc2440.c b/src/rfc2440.c
index 5a1f296..fe15198 100644
--- a/src/rfc2440.c
+++ b/src/rfc2440.c
@@ -23,7 +23,12 @@
 #include <zlib.h>
 #endif
 #include <stdio.h>
+
+#ifdef __APPLE__
+#include <malloc/malloc.h>
+#else
 #include <malloc.h>
+#endif

 #include "xmalloc.h"
 #include "keys.h"
