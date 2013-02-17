require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://ftp.yar.ru/pub/source/lftp/lftp-4.4.3.tar.bz2'
  sha1 'f027fc0ee1069c8fa0ae665eeea742c16d58a5d8'

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
