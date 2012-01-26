require 'formula'

class Lftp < Formula
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.3.5.tar.bz2'
  homepage 'http://lftp.yar.ru/'
  md5 '9802867df48fb7c69d92dadf8fa86af6'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MacOS.leopard?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
