require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

class Netcdf < Formula
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.2.tar.gz'
  homepage 'http://www.unidata.ucar.edu/software/netcdf/'
  md5 '4a94ebe2d998d649159aa5665c83fb1a'

  depends_on 'hdf5'

  def options
    [['--enable-fortran', 'Compile Fortran bindings']]
  end

  def install
    ENV.fortran if fortran?
    ENV.append 'LDFLAGS', '-lsz' # So configure finds szip during HDF5 tests

    # HDF5 is required to create and access files in the version 4 format
    hdf5 = Formula.factory 'hdf5'

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-hdf5=#{hdf5.prefix}",
            "--enable-netcdf4",
            "--enable-shared",
            "--with-szlib=#{HOMEBREW_PREFIX}"]
    args << "--disable-fortran" unless fortran?

    system "./configure", *args
    system "make install"
  end
end
