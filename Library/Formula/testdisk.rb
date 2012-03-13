require 'formula'

class Testdisk < Formula
  url 'http://www.cgsecurity.org/testdisk-6.13.tar.bz2'
  homepage 'http://www.cgsecurity.org/wiki/TestDisk'
  md5 '3bcbf0722d3823ca155e633969ce9f0b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
