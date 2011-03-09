require 'formula'

class Fcrackzip <Formula
  url 'http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz'
  homepage 'http://oldhome.schmorp.de/marc/fcrackzip.html'
  md5 '254941f51759f9425965f4b05fe7ac2c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
