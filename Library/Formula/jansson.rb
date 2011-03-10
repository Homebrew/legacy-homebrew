require 'formula'

class Jansson < Formula
  url 'http://www.digip.org/jansson/releases/jansson-1.3.tar.gz'
  homepage 'http://www.digip.org/jansson/'
  md5 '329fc6dbfc20f09b64a1c7392a8afb7f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
