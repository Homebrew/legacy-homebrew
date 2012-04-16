require 'formula'

def grib2?
  ARGV.include? '--enable-grib2'
end

class Cdo < Formula
  homepage 'https://code.zmaw.de/projects/cdo'
  url 'https://code.zmaw.de/attachments/download/2372'
  md5 'ceacb1acfa921a5bf1a3e4cda1097405'
  version '1.5.4'

  depends_on 'netcdf'
  depends_on 'hdf5'
  depends_on 'grib-api' if grib2?
  
  def options
    [['--enable-grib2', 'Compile Fortran bindings']]
  end

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--with-netcdf=#{HOMEBREW_PREFIX}",
            "--with-hdf5=#{HOMEBREW_PREFIX}",
            "--with-szlib=#{HOMEBREW_PREFIX}"]
    args.concat ["--with-grib_api=#{HOMEBREW_PREFIX}",
                 "--with-jasper=#{HOMEBREW_PREFIX}"] if grib2?

    system "./configure", *args
    system "make install"
  end

  def test
    system "cdo -h"
  end
end
