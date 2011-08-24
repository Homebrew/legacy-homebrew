require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/3.28/+download/byobu_3.28.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '4c8b08924925c52fbdc02cebeeed3745'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
