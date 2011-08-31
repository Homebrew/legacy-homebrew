require 'formula'

class Jansson < Formula
  url 'http://www.digip.org/jansson/releases/jansson-2.0.1.tar.gz'
  homepage 'http://www.digip.org/jansson/'
  md5 'f7a62be6977ef465b45781b53e8365e7'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
