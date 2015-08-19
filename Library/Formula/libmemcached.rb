class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "http://libmemcached.org"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  revision 1

  bottle do
    cellar :any
    sha1 "bc3d5a76a9ab01adf8e2f1e5379ed22c929695dd" => :yosemite
    sha1 "252266ab9cd3465fd58be65d39b2f4a4247e96fc" => :mavericks
    sha1 "4622bbb54b807a894d4ace68d45d761b9d68d07f" => :mountain_lion
  end

  option "with-sasl", "Build with sasl support"

  if build.with? "sasl"
    depends_on "memcached" => "enable-sasl"
  else
    depends_on "memcached"
  end

  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patch :DATA

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    args = ["--prefix=#{prefix}"]

    if build.with? "sasl"
      args << "--with-memcached-sasl=#{Formula["memcached"].bin}/memcached"
    end

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/clients/memflush.cc b/clients/memflush.cc
index 8bd0dbf..71545ea 100644
--- a/clients/memflush.cc
+++ b/clients/memflush.cc
@@ -39,7 +39,7 @@ int main(int argc, char *argv[])
 {
   options_parse(argc, argv);
 
-  if (opt_servers == false)
+  if (opt_servers == NULL)
   {
     char *temp;
 
@@ -48,7 +48,7 @@ int main(int argc, char *argv[])
       opt_servers= strdup(temp);
     }
 
-    if (opt_servers == false)
+    if (opt_servers == NULL)
     {
       std::cerr << "No Servers provided" << std::endl;
       exit(EXIT_FAILURE);
diff --git a/example/byteorder.cc b/example/byteorder.cc
index fdfa021..8c03d35 100644
--- a/example/byteorder.cc
+++ b/example/byteorder.cc
@@ -42,27 +42,59 @@
 #include <example/byteorder.h>

 /* Byte swap a 64-bit number. */
-#ifndef swap64
-static inline uint64_t swap64(uint64_t in)
-{
-#ifndef WORDS_BIGENDIAN
-  /* Little endian, flip the bytes around until someone makes a faster/better
+#if !defined(htonll) && !defined(ntohll)
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+# if defined(__FreeBSD__)
+#  include <sys/endian.h>
+#  define htonll(x) bswap64(x)
+#  define ntohll(x) bswap64(x)
+# elif defined(__APPLE__)
+#  include <libkern/OSByteOrder.h>
+#  define htonll(x) OSSwapInt64(x)
+#  define ntohll(x) OSSwapInt64(x)
+# elif defined(__OpenBSD__)
+#  include <sys/types.h>
+#  define htonll(x) swap64(x)
+#  define ntohll(x) swap64(x)
+# elif defined(__NetBSD__)
+#  include <sys/types.h>
+#  include <machine/bswap.h>
+#  if defined(__BSWAP_RENAME) && !defined(__bswap_32)
+#   define htonll(x) bswap64(x)
+#   define ntohll(x) bswap64(x)
+#  endif
+# elif defined(__sun) || defined(sun)
+#  include <sys/byteorder.h>
+#  define htonll(x) BSWAP_64(x)
+#  define ntohll(x) BSWAP_64(x)
+# elif defined(_MSC_VER)
+#  include <stdlib.h>
+#  define htonll(x) _byteswap_uint64(x)
+#  define ntohll(x) _byteswap_uint64(x)
+# else
+#  include <byteswap.h>
+#  ifndef bswap_64
+   /* Little endian, flip the bytes around until someone makes a faster/better
    * way to do this. */
-  uint64_t rv= 0;
-  for (uint8_t x= 0; x < 8; x++)
-  {
-    rv= (rv << 8) | (in & 0xff);
-    in >>= 8;
-  }
-  return rv;
+   static inline uint64_t bswap_64(uint64_t in)
+   {
+      uint64_t rv= 0;
+      for (uint8_t x= 0; x < 8; x++)
+      {
+        rv= (rv << 8) | (in & 0xff);
+        in >>= 8;
+      }
+      return rv;
+   }
+#  endif
+#  define htonll(x) bswap_64(x)
+#  define ntohll(x) bswap_64(x)
+# endif
 #else
-  /* big-endian machines don't need byte swapping */
-  return in;
-#endif // WORDS_BIGENDIAN
-}
+# define htonll(x) (x)
+# define ntohll(x) (x)
+#endif
 #endif
-
-#ifdef HAVE_HTONLL

 uint64_t example_ntohll(uint64_t value)
 {
@@ -73,17 +105,3 @@ uint64_t example_htonll(uint64_t value)
 {
   return htonll(value);
 }
-
-#else // HAVE_HTONLL
-
-uint64_t example_ntohll(uint64_t value)
-{
-  return swap64(value);
-}
-
-uint64_t example_htonll(uint64_t value)
-{
-  return swap64(value);
-}
-
-#endif // HAVE_HTONLL
diff --git a/libmemcached-1.0/memcached.h b/libmemcached-1.0/memcached.h
index bc16e73..dcee395 100644
--- a/libmemcached-1.0/memcached.h
+++ b/libmemcached-1.0/memcached.h
@@ -43,7 +43,11 @@
 #endif

 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
 #  include <cinttypes>
+#else
+#  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #else
diff --git a/libmemcached/byteorder.cc b/libmemcached/byteorder.cc
index 9f11aa8..f167822 100644
--- a/libmemcached/byteorder.cc
+++ b/libmemcached/byteorder.cc
@@ -39,41 +39,66 @@
 #include "libmemcached/byteorder.h"

 /* Byte swap a 64-bit number. */
-#ifndef swap64
-static inline uint64_t swap64(uint64_t in)
-{
-#ifndef WORDS_BIGENDIAN
-  /* Little endian, flip the bytes around until someone makes a faster/better
+#if !defined(htonll) && !defined(ntohll)
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+# if defined(__FreeBSD__)
+#  include <sys/endian.h>
+#  define htonll(x) bswap64(x)
+#  define ntohll(x) bswap64(x)
+# elif defined(__APPLE__)
+#  include <libkern/OSByteOrder.h>
+#  define htonll(x) OSSwapInt64(x)
+#  define ntohll(x) OSSwapInt64(x)
+# elif defined(__OpenBSD__)
+#  include <sys/types.h>
+#  define htonll(x) swap64(x)
+#  define ntohll(x) swap64(x)
+# elif defined(__NetBSD__)
+#  include <sys/types.h>
+#  include <machine/bswap.h>
+#  if defined(__BSWAP_RENAME) && !defined(__bswap_32)
+#   define htonll(x) bswap64(x)
+#   define ntohll(x) bswap64(x)
+#  endif
+# elif defined(__sun) || defined(sun)
+#  include <sys/byteorder.h>
+#  define htonll(x) BSWAP_64(x)
+#  define ntohll(x) BSWAP_64(x)
+# elif defined(_MSC_VER)
+#  include <stdlib.h>
+#  define htonll(x) _byteswap_uint64(x)
+#  define ntohll(x) _byteswap_uint64(x)
+# else
+#  include <byteswap.h>
+#  ifndef bswap_64
+   /* Little endian, flip the bytes around until someone makes a faster/better
    * way to do this. */
-  uint64_t rv= 0;
-  for (uint8_t x= 0; x < 8; ++x)
-  {
-    rv= (rv << 8) | (in & 0xff);
-    in >>= 8;
-  }
-  return rv;
+   static inline uint64_t bswap_64(uint64_t in)
+   {
+      uint64_t rv= 0;
+      for (uint8_t x= 0; x < 8; x++)
+      {
+        rv= (rv << 8) | (in & 0xff);
+        in >>= 8;
+      }
+      return rv;
+   }
+#  endif
+#  define htonll(x) bswap_64(x)
+#  define ntohll(x) bswap_64(x)
+# endif
 #else
-  /* big-endian machines don't need byte swapping */
-  return in;
-#endif // WORDS_BIGENDIAN
-}
+# define htonll(x) (x)
+# define ntohll(x) (x)
+#endif
 #endif
-

 uint64_t memcached_ntohll(uint64_t value)
 {
-#ifdef HAVE_HTONLL
   return ntohll(value);
-#else
-  return swap64(value);
-#endif
 }

 uint64_t memcached_htonll(uint64_t value)
 {
-#ifdef HAVE_HTONLL
   return htonll(value);
-#else
-  return swap64(value);
-#endif
 }
