require 'formula'

class Hdf5 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.5.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  md5 'a400fe6c1c5964a7224dc684225d415c'

  depends_on 'szip'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
