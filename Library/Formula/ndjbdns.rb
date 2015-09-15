class Ndjbdns < Formula
  desc "N-DJBDNS is a brand new release of DJBDNS."
  homepage "http://pjp.dgplug.org/djbdns/"
  url "http://pjp.dgplug.org/djbdns/ndjbdns-1.06.tar.gz"
  sha256 "5ce5a7c5031f220a85fc8bca903f2d3cf484ff77e4c85e7144a0e2a5922a1127"
  
  depends_on "autoconf"
  depends_on "automake"

  # Patch while waiting upstream to fix: https://github.com/pjps/ndjbdns/issues/17
  patch :DATA

  def install
    bin.mkpath
    (prefix+"etc").mkpath
    # disable the chance of init.d ./etc setup
    inreplace "etc/Makefile.am", "SUBDIRS = ip init.d servers", "SUBDIRS = ip servers"
    system "autoreconf -if"
    system "./configure --prefix=#{prefix} --sysconfdir=#{etc}"
    system "make"
    system "make install"
    inreplace "#{etc}/ndjbdns/axfrdns.conf",  /^([UG]ID)=\d+/, '\1=1'
    inreplace "#{etc}/ndjbdns/dnscache.conf", /^([UG]ID)=\d+/, '\1=1'
    inreplace "#{etc}/ndjbdns/dnscache.conf", /IP=.+/, 'IP=0.0.0.0'
    inreplace "#{etc}/ndjbdns/rbldns.conf",   /^([UG]ID)=\d+/, '\1=1'
    inreplace "#{etc}/ndjbdns/tinydns.conf",  /^([UG]ID)=\d+/, '\1=1'
    inreplace "#{etc}/ndjbdns/walldns.conf",  /^([UG]ID)=\d+/, '\1=1'
  end

  test do
    # would need to run a server process in the background
    #system "#{bin}/dnscache -P 1053"
    system "dnsip localhost"
  end

  conflicts_with 'djbdns',
    :because => 'both install the same binaries'

end


# Patch while waiting upstream to fix: https://github.com/pjps/ndjbdns/issues/17
__END__
diff --git a/common.c b/common.c
index 670c9bb..fbf4a1f 100644
--- a/common.c
+++ b/common.c
@@ -68,6 +68,51 @@ extend_buffer (char **buf)
     return n;
 }
 
+#if defined(__APPLE__) && defined(__MACH__)
+
+/*      $OpenBSD: memrchr.c,v 1.2 2007/11/27 16:22:12 martynas Exp $    */
+
+/*
+ * Copyright (c) 2007 Todd C. Miller <Todd.Miller@courtesan.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * $FreeBSD$
+ */
+
+#include <string.h>
+
+/*
+ * Reverse memchr()
+ * Find the last occurrence of 'c' in the buffer 's' of size 'n'.
+ */
+void *
+memrchr(const void *s, int c, size_t n)
+{
+        const unsigned char *cp;
+
+        if (n != 0) {
+                cp = (unsigned char *)s + n;
+                do {
+                        if (*(--cp) == (unsigned char)c)
+                                return((void *)cp);
+                } while (--n != 0);
+        }
+        return(NULL);
+}
+
+#elif
+
 size_t
 getline (char **lineptr, ssize_t *n, FILE *stream)
 {
@@ -93,6 +138,8 @@ getline (char **lineptr, ssize_t *n, FILE *stream)
     return i;
 }
 
+#endif
+
 #endif      /* #ifndef __USE_GNU */
