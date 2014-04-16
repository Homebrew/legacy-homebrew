require 'formula'

class Loudmouth < Formula
  homepage 'http://mcabber.com'
  url 'http://mcabber.com/files/loudmouth-1.5.0-20121201.tar.bz2'
  version '1.5.0.20121201'
  sha1 '502963c3068f7033bb21d788918c1e5cd14f386e'

  option 'with-gnutls', "Use GnuTLS instead of the default OpenSSL"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls' => :optional
  depends_on 'libidn'

  # Fix compilation on 10.9. Sent upstream:
  # https://github.com/mcabber/loudmouth/pull/9
  patch :DATA

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    if build.with? 'gnutls'
     args << "--with-ssl=gnutls"
    else
     args << "--with-ssl=openssl"
    end
    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/loudmouth/lm-sock.c b/loudmouth/lm-sock.c
index f3a2803..6e99eca 100644
--- a/loudmouth/lm-sock.c
+++ b/loudmouth/lm-sock.c
@@ -314,6 +314,13 @@ gboolean
 _lm_sock_set_keepalive (LmOldSocketT sock, int delay)
 {
 #ifdef USE_TCP_KEEPALIVES
+
+#ifdef __APPLE__
+#ifndef TCP_KEEPIDLE
+#define TCP_KEEPIDLE TCP_KEEPALIVE
+#endif
+#endif
+
     int opt;
 
     opt = 1;
