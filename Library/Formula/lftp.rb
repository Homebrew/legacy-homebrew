require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://ftp.yars.free.net/pub/source/lftp/lftp-4.3.6.tar.bz2'
  sha1 '8f32802b87e9a1b5d4f0a79db97e94b335854a60'

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
