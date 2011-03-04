require 'formula'

class Hdf5 <Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.5-patch1.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  md5 '27308a145e6c208d57db3f6f2634a0f6'
  version '1.8.5-patch1'

  depends_on 'szip'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
