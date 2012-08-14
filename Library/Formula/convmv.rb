require 'formula'

class Convmv < Formula
  homepage 'http://www.j3e.de/linux/convmv/'
  url 'http://www.j3e.de/linux/convmv/convmv-1.15.tar.gz'
  md5 'b1bb703c08c6355868d15890ff193f7d'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
