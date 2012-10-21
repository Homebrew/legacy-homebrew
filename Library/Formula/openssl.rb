require 'formula'

class Openssl < Formula
  homepage 'http://openssl.org'
  url 'http://openssl.org/source/openssl-1.0.1c.tar.gz'
  sha256 '2a9eb3cd4e8b114eb9179c0d3884d61658e7d8e8bf4984798a5f5bd48e325ebe'

  keg_only :provided_by_osx,
    "The OpenSSL provided by OS X is too old for some software."

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
