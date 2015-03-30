class Trafficserver < Formula
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-5.2.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-5.2.0.tar.bz2"
  sha256 "e3a265dd3188edaa7b8ad2bb54b0030c23588b48abb02890363db1374aac68d3"
  revision 1

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  bottle do
    sha256 "26c2989bc8abffcb704dfec98738bfe64788bd857f4e33f1559d843d585d19fb" => :yosemite
    sha256 "720cf540ae6d4088a463cd57ed2d683b3641ac96615d5b97fcd89102595ceb48" => :mavericks
    sha256 "cef715a09849d0ce15a0cb446e3ed2a471f822361c82c4d7b04e3420d75e7373" => :mountain_lion
  end

  option "with-spdy", "Build with SPDY protocol support"

  depends_on "openssl"
  depends_on "pcre"
  if build.with? "spdy"
    depends_on "spdylay"
    depends_on "pkg-config" => :build
  end

  # patch openssl 1.0.2 tls1.h detection, remove on 5.3.0 (upstream bug TS-3443)
  patch :DATA if build.stable?

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
    system "./configure", *args
    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", '$USER'
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
