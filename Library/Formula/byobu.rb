require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/4.30/+download/byobu_4.30.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 'fc2852d1d1cf68282af0a24a680b87f6'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
