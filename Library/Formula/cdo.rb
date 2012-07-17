require 'formula'

def grib2?
  ARGV.include? '--enable-grib2'
end

class Cdo < Formula
  homepage 'https://code.zmaw.de/projects/cdo'
  url 'https://code.zmaw.de/attachments/download/2879/cdo-1.5.5.tar.gz'
  md5 '8072ebfebfa6a2c9b4ee4098d9fec338'

  depends_on 'netcdf'
  depends_on 'hdf5'
  depends_on 'grib-api' if grib2?

  def options
    [['--enable-grib2', 'Compile Fortran bindings']]
  end

  def install
    ENV['CFLAGS'] += " -D_REENTRANT"
    ENV['CFLAGS'] += " -fopenmp" if not MacOS.leopard? and ENV.compiler == :gcc

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-netcdf=#{HOMEBREW_PREFIX}",
            "--with-hdf5=#{HOMEBREW_PREFIX}",
            "--with-szlib=#{HOMEBREW_PREFIX}"]

    if grib2?
      args << "--with-grib_api=#{HOMEBREW_PREFIX}"
      args << "--with-jasper=#{HOMEBREW_PREFIX}"
    end

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/cdo", "-h"
  end
end
