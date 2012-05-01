require 'formula'

class GribApi < Formula
  url 'http://www.ecmwf.int/products/data/software/download/software_files/grib_api-1.9.16.tar.gz'
  homepage 'http://www.ecmwf.int/products/data/software/grib_api.html'
  md5 '490cda08585e263d9f13daed4e7b688c'

  depends_on 'jasper'

  fails_with :clang do
    build 318
    cause 'Undefined symbols when linking.'
  end

  def install
    ENV.deparallelize
    ENV.no_optimization
    ENV.fortran

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
