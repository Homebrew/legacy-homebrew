require 'formula'

class Testdisk < Formula
  url 'http://www.cgsecurity.org/testdisk-6.13.tar.bz2'
  homepage 'http://www.cgsecurity.org/wiki/TestDisk'
  sha1 'b08ace0257e3e437b6fc140360d75807ca4d46ae'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
