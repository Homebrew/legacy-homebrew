require 'formula'

class Szip < Formula
  url 'http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz'
  homepage 'http://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs'
  sha1 'd241c9acc26426a831765d660b683b853b83c131'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
