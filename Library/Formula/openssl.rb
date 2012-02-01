require 'formula'

class Openssl < Formula
  url 'http://www.openssl.org/source/openssl-1.0.0g.tar.gz'
  version '1.0.0g'
  homepage 'http://www.openssl.org'
  sha1 '2b517baada2338663c27314cb922f9755e73e07f'

  keg_only :provided_by_osx,
    "The OpenSSL provided by Leopard (0.9.7) and by Lion (0.9.8) are too old for some software."

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
