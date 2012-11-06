require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://ftp.yar.ru/pub/source/lftp/lftp-4.4.0.tar.bz2'
  sha1 '4eef63d05760a0e7d6d6a7318e1fcda8de8c154e'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    ENV.no_optimization if MacOS.version == :leopard

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
