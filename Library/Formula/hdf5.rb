require 'formula'

class Hdf5 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.4.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  md5 'c13599cfff871948f4d00e19ac410b86'

  depends_on 'szip'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
