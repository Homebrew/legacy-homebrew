require 'formula'

class Jansson < Formula
  url 'http://www.digip.org/jansson/releases/jansson-2.1.tar.gz'
  homepage 'http://www.digip.org/jansson/'
  md5 '9d9cff669b79cecc60d68141afd74e9d'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
