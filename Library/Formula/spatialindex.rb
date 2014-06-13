require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.io'
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.1.tar.gz"
  sha1 "c05f8d081316a163aef117b7fd99811539ec421c"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
