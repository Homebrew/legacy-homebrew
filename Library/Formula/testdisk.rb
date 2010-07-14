require 'formula'

class Testdisk <Formula
  url 'http://www.cgsecurity.org/testdisk-6.11.tar.bz2'
  homepage 'http://www.cgsecurity.org/wiki/TestDisk'
  md5 '11f8fe95dcd190b69b782efa65b29ba1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
