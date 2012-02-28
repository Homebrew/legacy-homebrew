require 'formula'

class Openssl < Formula
  url 'http://www.openssl.org/source/openssl-0.9.8s.tar.gz'
  version '0.9.8s'
  homepage 'http://www.openssl.org'
  sha1 'a7410b0991f37e125bf835dfd1315822fca64d56'

  keg_only :provided_by_osx,
    "The OpenSSL provided by Leopard (0.9.7) is too old for some software."

  def install
    system "./config", "--prefix=#{prefix}",
                       "--openssldir=#{etc}/openssl",
                       "zlib-dynamic", "shared"

    ENV.deparallelize # Parallel compilation fails
    system "make"
    system "make test"
    system "make install MANDIR=#{man} MANSUFFIX=ssl"
  end

  def caveats; <<-EOS.undent
    Note that the libraries built tend to be 32-bit only, even on Snow Leopard.
    EOS
  end
end
