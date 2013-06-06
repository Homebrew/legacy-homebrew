require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://ftp.yar.ru/pub/source/lftp/lftp-4.4.8.tar.bz2'
  mirror 'ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-4.4.8.tar.bz2'
  sha1 'c825849d90b8132ed43ea5b73fdbb6a63f3e44de'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MacOS.version == :leopard

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
