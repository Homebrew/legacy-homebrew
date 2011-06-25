require 'formula'

class Convmv < Formula
  url 'http://www.j3e.de/linux/convmv/convmv-1.14.tar.gz'
  homepage 'http://www.j3e.de/linux/convmv/'
  md5 'd41238051c13b2e6c0cc2310a8f69d68'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
