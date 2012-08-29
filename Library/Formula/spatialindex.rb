require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.com'
  url 'http://download.osgeo.org/libspatialindex/spatialindex-src-1.7.1.tar.gz'
  md5 '8599243d5d8204f0f8d92cd55ab120f5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
