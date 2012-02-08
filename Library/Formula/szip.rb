require 'formula'

class Szip < Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz'
  homepage 'http://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs'
  md5 '902f831bcefb69c6b635374424acbead'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
