require 'formula'

class Szip < Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz'
  homepage 'http://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs'
  md5 '1e0621efa66c2e1b07d7659703df5ea8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
