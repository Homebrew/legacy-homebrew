require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://lftp.yar.ru/ftp/lftp-4.4.10.tar.bz2'
  mirror 'ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-4.4.10.tar.bz2'
  sha1 '0fc98664e572256f280a5b57d279d3b415a87fce'

  # https://github.com/mxcl/homebrew/issues/18749
  env :std

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  def install
    # Bus error
    # TODO what are the more specific circumstances?
    ENV.no_optimization if MacOS.version <= :leopard

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
