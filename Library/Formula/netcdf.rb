require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

def no_cxx?
  ARGV.include? '--disable-cxx'
end

class NetcdfCXX < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.2.tar.gz'
  md5 'd019853802092cf686254aaba165fc81'
end

class NetcdfFortran < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.2.tar.gz'
  md5 'cc3bf530223e8f4aff93793b9f197bf3'
end

class Netcdf < Formula
  homepage 'http://www.unidata.ucar.edu/software/netcdf'
  url 'http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.2.tar.gz'
  md5 'b920a6c3a30e9cd46fe96d9fb65ef17e'

  depends_on 'hdf5'

  def options
    [
      ['--enable-fortran', 'Compile Fortran bindings'],
      ['--disable-cxx', "Don't compile C++ bindings"]
    ]
  end

  def install
    common_args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
      --enable-shared
    ]

    args = common_args.clone
    args << '--enable-netcdf4'

    system './configure', *args
    system 'make install'

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    ENV.prepend 'PATH', bin
    ENV.prepend 'CPPFLAGS', "-I#{include}"
    ENV.prepend 'LDFLAGS', "-L#{lib}"

    NetcdfCXX.new.brew do
      system './configure', *common_args
      system 'make install'
    end unless no_cxx?

    NetcdfFortran.new.brew do
      ENV.fortran

      system './configure', *common_args
      system 'make install'
    end if fortran?
  end
end
