require 'formula'

class Openssl < Formula
  homepage 'http://www.openssl.org'
  url 'http://www.openssl.org/source/openssl-0.9.8s.tar.gz'
  sha1 'a7410b0991f37e125bf835dfd1315822fca64d56'

  keg_only :provided_by_osx,
    "The OpenSSL provided by Leopard (0.9.7) is too old for some software."

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
    system "make test"
    system "make install MANDIR=#{man} MANSUFFIX=ssl"
  end
end
