require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/4.17/+download/byobu_4.17.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '9f6921e870706df00c95df0c891925b9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
