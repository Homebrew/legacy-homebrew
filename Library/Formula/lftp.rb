require 'formula'

class Lftp < Formula
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.2.1.tar.bz2'
  homepage 'http://lftp.yar.ru/'
  md5 '244c52690afbc2bdb6ec6af9496434b3'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MacOS.leopard?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
