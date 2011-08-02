require 'formula'

class Testdisk < Formula
  url 'http://www.cgsecurity.org/testdisk-6.12.tar.bz2'
  homepage 'http://www.cgsecurity.org/wiki/TestDisk'
  md5 '6ef653301f309156f3a802233a3139c1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
