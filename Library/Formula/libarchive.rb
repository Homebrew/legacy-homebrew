require 'formula'

class Libarchive <Formula
  url 'http://libarchive.googlecode.com/files/libarchive-2.8.3.tar.gz'
  homepage 'http://code.google.com/p/libarchive/'
  md5 'fe8d917e101d4b37580124030842a1d0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
