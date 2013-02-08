require 'formula'

class Openssl < Formula
  homepage 'http://openssl.org'
  url 'http://openssl.org/source/openssl-1.0.1d.tar.gz'
  sha256 '88a423f9b08a994054583691b968815875580e12df754e881d7cfe9f1bd1f49d'

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
