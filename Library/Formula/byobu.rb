require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/3.29/+download/byobu_3.29.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '10ce12db8d52f2c50ca9c94c53938c6d'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
