require 'formula'

class Szip < Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz'
  homepage 'http://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs'
  md5 '0d6a55bb7787f9ff8b9d608f23ef5be0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
