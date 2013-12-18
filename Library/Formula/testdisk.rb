require 'formula'

class Testdisk < Formula
  homepage 'http://www.cgsecurity.org/wiki/TestDisk'
  url 'http://www.cgsecurity.org/testdisk-6.14.tar.bz2'
  sha1 'a2359406db5e3e3f9db81d8e8fce2a125dcc3677'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
