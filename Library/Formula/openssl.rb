require 'formula'

class Openssl < Formula
  homepage 'http://openssl.org'
  url 'http://openssl.org/source/openssl-1.0.1a.tar.gz'
  sha256 'd3487e09d891c772cf946273a3bb0ca47479e7941be6d822274320e7cfcc361b'

  keg_only :provided_by_osx,
    "The OpenSSL provided by OS X is too old for some software."

  def patches
    # Fixed regression with Mac OS X and 64-bit.
    # http://rt.openssl.org/Ticket/Display.html?id=2797
    # Can be removed with next release. Please check first.
    DATA
  end

  def install
    args = %W[./Configure
               --prefix=#{prefix}
               --openssldir=#{etc}/openssl
               zlib-dynamic
               shared
             ]

    args << (MacOS.prefer_64_bit? ? "darwin64-x86_64-cc" : "darwin-i386-cc")

    system "perl", *args

    ENV.deparallelize # Parallel compilation fails
    system "make"
    system "make", "test"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end
end

__END__
diff --git i/crypto/evp/e_rc4_hmac_md5.c w/crypto/evp/e_rc4_hmac_md5.c
index 3f32b25..e65380d 100644
--- i/crypto/evp/e_rc4_hmac_md5.c
+++ w/crypto/evp/e_rc4_hmac_md5.c
@@ -103,7 +103,8 @@ static int rc4_hmac_md5_init_key(EVP_CIPHER_CTX *ctx,
 #if	!defined(OPENSSL_NO_ASM) &&	( \
 	defined(__x86_64)	|| defined(__x86_64__)	|| \
 	defined(_M_AMD64)	|| defined(_M_X64)	|| \
-	defined(__INTEL__)		)
+	defined(__INTEL__)		) && \
+	!(defined(__APPLE__) && defined(__MACH__))
 #define	STITCHED_CALL
 #endif
