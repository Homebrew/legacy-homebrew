require 'formula'

# GnuTLS has previous, current, and next stable branches, we use current.
class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.17.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.17.tar.xz'
  sha1 'c48b02912c5dc77b627f1f17dcc05c2be1d59b0f'

  bottle do
    cellar :any
    sha1 "9afca62450a3a74d91ee70a5ae11624310b7a755" => :yosemite
    sha1 "3e4d0c1cd43da26defe0620b1c619be532e5b536" => :mavericks
    sha1 "3eb9d4d68f26cf9589d417db111da503951799e9" => :mountain_lion
    sha1 "d5cef16200d281b8ac69957d2f4c0c436b2c766e" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'gmp'
  depends_on 'nettle'
  depends_on 'guile' => :optional
  depends_on 'p11-kit' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Fix use of stdnoreturn header on Lion
  # https://www.gitorious.org/gnutls/gnutls/commit/9d2a2d17c0e483f056f98084955fba82b166bd56
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
    ]

    if build.with? 'guile'
      args << '--enable-guile'
      args << '--with-guile-site-dir=no'
    end

    system "./configure", *args
    system "make install"

    # certtool shadows the OS X certtool utility
    mv bin+'certtool', bin+'gnutls-certtool'
    mv man1+'certtool.1', man1+'gnutls-certtool.1'
  end

  def post_install
    Formula["openssl"].post_install
  end
end

__END__
--- a/src/libopts/autoopts.h
+++ b/src/libopts/autoopts.h
@@ -32,7 +32,14 @@

 #ifndef AUTOGEN_AUTOOPTS_H
 #define AUTOGEN_AUTOOPTS_H
-#include <stdnoreturn.h>
+
+#ifdef HAVE_STDNORETURN_H
+# include <stdnoreturn.h>
+#else
+# ifndef noreturn
+#  define noreturn
+# endif
+#endif

 #define AO_NAME_LIMIT           127
 #define AO_NAME_SIZE            ((size_t)(AO_NAME_LIMIT + 1))
