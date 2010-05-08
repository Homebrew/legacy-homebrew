require 'formula'

class Netcdf <Formula
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.1.tar.gz'
  homepage 'http://www.unidata.ucar.edu/software/netcdf/'
  md5 '79c5ff14c80d5e18dd8f1fceeae1c8e1'

  depends_on 'hdf5'
  depends_on 'szip'

  def install
    hdf5 = Formula.factory('hdf5')
    szip = Formula.factory('szip')

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-szip=#{szip.prefix}",
                          "--with-hdf5=#{hdf5.prefix}"
    system "make install"
  end
end
