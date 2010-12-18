require 'formula'

class Netcdf <Formula
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.1.tar.gz'
  homepage 'http://www.unidata.ucar.edu/software/netcdf/'
  md5 '79c5ff14c80d5e18dd8f1fceeae1c8e1'

  depends_on 'hdf5'
  depends_on 'gfortran' if ARGV.include? '--fortran'

  def options
    [['--fortran', 'Compile with Fortran support']]
  end

  def install
    # HDF5 is required to create and access files in the version 4 format
    hdf5 = Formula.factory('hdf5')

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-hdf5=#{hdf5.prefix}",
            "--enable-netcdf4",
            "--enable-shared"]
    args << "--disable-fortran" unless ARGV.include? '--fortran'

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS
To build with (experimental) fortran support:
  brew install netcdf --fortran

You may have to set FCFLAGS and FFLAGS to be consistant with Homebrew's use
of C compilers in order for the brew to install correctly.
    EOS
  end
end
