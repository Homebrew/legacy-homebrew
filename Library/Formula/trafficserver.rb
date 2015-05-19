class Trafficserver < Formula
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-5.2.1.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-5.2.1.tar.bz2"
  sha256 "7980be2c1b95d9b1c6b91d6a8ab88e24a8c31b36acd2d02c4df8c47dc18e6b1d"

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  bottle do
    sha256 "d1c423b0fcd28528be7cb5538535ea5a3c3e1bbe7d9a6116ecad8529b242a0d4" => :yosemite
    sha256 "cd3cd2a117f56ccb1ab37a442f39b888d552d73f50eb1f5d197ad67556e94e9c" => :mavericks
    sha256 "891a45f79c0af21bbb3d50a433839683fa636ca866e8493a217828db69da38dc" => :mountain_lion
  end

  option "with-spdy", "Build with SPDY protocol support"
  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"
  if build.with? "spdy"
    depends_on "spdylay"
    depends_on "pkg-config" => :build
  end

  # Patch 1: OpenSSL 1.0.2+ tls1.h detection, remove on 5.3.0 (upstream bug TS-3443)
  # Patch 2: Xcode 6.3 compile fix, remove on 5.3.0 (upstream bug TS-3302)
  stable do
    patch :DATA
  end

  def install
    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"
    system "autoreconf", "-fvi" if build.head?
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--with-openssl=#{Formula["openssl"].opt_prefix}",
      "--with-user=#{ENV["USER"]}",
      "--with-group=admin"
    ]
    args << "--enable-spdy" if build.with? "spdy"
    args << "--enable-experimental-plugins" if build.with? "experimental-plugins"
    system "./configure", *args
    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", '$USER'
    if build.with? "experimental-plugins"
      # Disable mysql_remap plugin due to missing symbol compile error (upstream bug TS-3490)
      inreplace "plugins/experimental/Makefile", " mysql_remap", ""
    end
    system "make" if build.head?
    system "make", "install"
  end

  test do
    system "#{bin}/trafficserver", "status"
  end
end

__END__
--- a/configure	2015-03-15 05:01:02.000000000 +0100
+++ b/configure	2015-03-15 05:08:09.000000000 +0100
@@ -22608,7 +22608,7 @@
     done
   fi

-  for ac_header in openssl/tls1.h openssl/ssl.h openssl/ts.h
+  for ac_header in openssl/ssl.h openssl/ts.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
@@ -22621,6 +22621,22 @@

 done

+  for ac_header in openssl/tls1.h
+do :
+  ac_fn_c_check_header_compile "$LINENO" "openssl/tls1.h" "ac_cv_header_openssl_tls1_h" " #if HAVE_OPENSSL_SSL_H
+#include <openssl/ssl.h>
+#include <openssl/tls1.h>
+#endif
+"
+if test "x$ac_cv_header_openssl_tls1_h" = xyes; then :
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_OPENSSL_TLS1_H 1
+_ACEOF
+
+fi
+
+done
+
   # We are looking for SSL_CTX_set_tlsext_servername_callback, but it's a
   # macro, so AC_CHECK_FUNCS is not going to do the business.
   { $as_echo "$as_me:${as_lineno-$LINENO}: checking for SSL_CTX_set_tlsext_servername_callback" >&5
diff --git a/lib/ts/IntrusiveDList.h b/lib/ts/IntrusiveDList.h
index 81a5192..b79ab10 100644
--- a/lib/ts/IntrusiveDList.h
+++ b/lib/ts/IntrusiveDList.h
@@ -42,13 +42,8 @@

  */

-# if USE_STL
-#   include <iterator>
-# else
-namespace std {
-  struct bidirectional_iterator_tag;
-}
-# endif
+/// FreeBSD doesn't like just declaring the tag struct we need so we have to include the file.
+# include <iterator>

 /** Intrusive doubly linked list container.
