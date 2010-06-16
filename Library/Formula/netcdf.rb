require 'formula'

class Netcdf <Formula
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.1.1.tar.gz'
  homepage 'http://www.unidata.ucar.edu/software/netcdf/'
  md5 '79c5ff14c80d5e18dd8f1fceeae1c8e1'

  depends_on 'hdf5'

  def install
    # HDF5 is required to create and access files
    # in the NetCDF version 4 format.
    hdf5 = Formula.factory('hdf5')

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-hdf5=#{hdf5.prefix}",
                          "--enable-netcdf4",
                          "--disable-fortran",  # Until issue 72 is resolved.
                          "--enable-shared"
    system "make install"
  end

  def caveats
    caveats = <<-EOS
This brew of NetCDF does not include Fortran support.
Fortran support will be added once the following issue
is resolved:

  http://github.com/mxcl/homebrew/issues/72

If you have a Fortran compiler and would like to enable
NetCDF support for Fortran compilers, execute:

  brew edit netcdf

Comment out the configure argument disabling Fortran
and re-install.  You may have to set FCFLAGS and FFLAGS
to be consistant with Homebrew's use of C compilers in
order for the brew to install correctly.

Be aware that the Homebrew project may not be able to
provide support for any issues that arise during
compilation when Fortran is enabled until a Fortran
compiler is officially supported.
    EOS
    
  end

end
