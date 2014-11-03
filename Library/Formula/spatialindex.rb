require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.io'
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha1 "08af1fefd0a30c895d7d714056c2a8f021f46eb4"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
