require 'formula'

class Hdf5 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.6.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  sha1 '348bd881c03a9568ac4ea9071833d6119c733757'
  version '1.8.6'

  depends_on 'szip'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
