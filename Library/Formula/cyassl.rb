require 'formula'

class Cyassl < Formula
  homepage 'http://yassl.com/yaSSL/Products-cyassl.html'
  url 'https://github.com/cyassl/cyassl/archive/v2.4.6.tar.gz'
  sha256 '0a51ac204edd38ab01b226e7248d7e01753a750276dc5e75159f5b0090be3eeb'

  # Enable when the next release it shipped. Breaks with inline patch.
  head 'https://github.com/cyassl/cyassl.git'

  depends_on :automake
  depends_on :libtool

  option 'enable-dtsl', 'Enable DTLS support.'
  option 'enable-sniffer', 'Enable sniffer support.'

  def patches
    # The patch contain two bits. One that needs to be added as we use autogen.sh,
    # and this is broken for CyaSSL. They depend on a .git folder present.
    # The second part can be removed with the next release. Fixed upstream.
    DATA
  end

  fails_with :clang do
    build 421
  end

  def install
    args = %W[--prefix=#{prefix}
              --enable-aesgcm
              --enable-certgen
              --enable-crl
              --enable-crl-monitor
              --enable-fortress
              --enable-hc128
              --enable-keygen
              --enable-ocsp
              --enable-opensslExtra
              --enable-ripemd
              --enable-sha512
              --disable-debug
              --disable-ecc
              --disable-noFilesystem
              --disable-noInline
              --disable-ntru
              --disable-small
              --with-libz
    ]

    args << '--enable-dtsl' if build.include? 'enable-dtsl'
    args << '--enable-sniffer' if build.include? 'enable-sniffer'

    if MacOS.prefer_64_bit?
      args << '--enable-fastmath' << '--enable-fasthugemath' << '--enable-bump'
    else
      args << '--disable-fastmath' << '--disable-fasthugemath' << '--disable-bump'
    end

    # Extra flag is stated as a needed for the Mac platform.
    # http://yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags '-mdynamic-no-pic' if MacOS.prefer_64_bit?

    # They don't provide a public release, so that we use a tag from their repo instead.
    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make install"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index f16dbd7..ed78895 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -10,4 +10,3 @@ else
 fi

 autoreconf --install --force --verbose
-ln -s -f ../../pre-commit.sh .git/hooks/pre-commit
