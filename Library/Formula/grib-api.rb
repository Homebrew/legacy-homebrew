require 'formula'

class GribApi < Formula
  homepage 'http://www.ecmwf.int/products/data/software/grib_api.html'
  url 'http://www.ecmwf.int/products/data/software/download/software_files/grib_api-1.9.16.tar.gz'
  sha1 'fd85e8b939231d4d8f9dc3131fa0aab73fbbcf78'

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
