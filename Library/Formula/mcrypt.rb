require "formula"

class Mcrypt < Formula
  homepage "http://mcrypt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz"
  sha1 "8ae0e866714fbbb96a0a6fa9f099089dc93f1d86"

  depends_on "mhash"

  resource "libmcrypt" do
    url "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
    sha1 "9a426532e9087dd7737aabccff8b91abf9151a7a"
  end

  option :universal

  # Patch to correct inclusion of malloc function on OSX.
  # Upstream: https://sourceforge.net/p/mcrypt/patches/14/
  def patches
    DATA
  end

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
