require 'formula'

class Liblas < Formula
  url 'http://trac.liblas.org/raw-attachment/wiki/1.6.0b1/libLAS-1.6.0b1.tar.gz'
  homepage 'http://liblas.org'
  md5 '4a08325b7daf4006e3762804d722b770'

  depends_on 'cmake'
  depends_on 'libgeotiff'
  depends_on 'gdal'
  depends_on 'boost'

  def install
    system "BOOST_ROOT=#{HOMEBREW_PREFIX} BOOST_INCLUDEDIR=#{HOMEBREW_PREFIX}/include cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
