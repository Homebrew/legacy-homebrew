require 'formula'

class Hdf5 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.4-patch1.tar.bz2'
  version '1.8.4-patch1'
  homepage 'http://www.hdfgroup.org/HDF5/'
  md5 'b19f4dfbf654a2af3653c492fc1c7513'

  depends_on 'szip'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
