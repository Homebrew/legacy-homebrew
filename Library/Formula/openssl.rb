require 'formula'

class Openssl < Formula
  homepage 'http://openssl.org'
  url 'http://openssl.org/source/openssl-1.0.1a.tar.gz'
  sha256 'd3487e09d891c772cf946273a3bb0ca47479e7941be6d822274320e7cfcc361b'

  keg_only :provided_by_osx,
    "The OpenSSL provided by OS X is too old for some software."

  def install
    args = %W[./Configure
               --prefix=#{prefix}
               --openssldir=#{etc}/openssl
               no-asm
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
