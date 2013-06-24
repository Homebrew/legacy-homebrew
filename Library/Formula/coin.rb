require 'formula'

class Coin < Formula
  homepage 'https://bitbucket.org/Coin3D/coin/wiki/Home'
  url 'https://bitbucket.org/Coin3D/coin/downloads/Coin-3.1.3.tar.gz'
  sha1 '8e9f05628461963623686d3ec53102214e233dd1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-framework-prefix=#{lib}"
    system "make install"
  end

end
