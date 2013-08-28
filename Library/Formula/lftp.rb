require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://lftp.yar.ru/ftp/lftp-4.4.9.tar.bz2'
  mirror 'ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-4.4.9.tar.bz2'
  sha1 'f7035e0c558222654511f17db3213262bc4b53fd'

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
