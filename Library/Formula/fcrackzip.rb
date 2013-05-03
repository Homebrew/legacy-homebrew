require 'formula'

class Fcrackzip < Formula
  homepage 'http://oldhome.schmorp.de/marc/fcrackzip.html'
  url 'http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz'
  sha1 '92e4f8caa880c55b20e13feb7a25c8b8fd3accf8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
