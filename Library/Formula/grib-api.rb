require 'formula'

class GribApi < Formula
  url 'http://www.ecmwf.int/products/data/software/download/software_files/grib_api-1.9.9.tar.gz'
  homepage 'http://www.ecmwf.int/products/data/software/grib_api.html'
  md5 'fe6c684e4a41477f3a6e97ab8892f35d'

  depends_on 'jasper'

  def install
    ENV.deparallelize
    ENV.no_optimization
    ENV.fortran

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
