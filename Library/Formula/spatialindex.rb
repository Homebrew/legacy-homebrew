require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.com'
  url 'http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.0.tar.gz'
  sha1 '490347eaedc543298687dfbdf74853808b0afb3f'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
