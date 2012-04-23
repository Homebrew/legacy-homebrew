require 'formula'

class Openssl < Formula
  homepage 'http://www.openssl.org'
  url 'http://www.openssl.org/source/openssl-1.0.1.tar.gz'
  sha1 'a6476d33fd38c2e7dfb438d1e3be178cc242c907'

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
