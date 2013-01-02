require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.com'
  url 'http://download.osgeo.org/libspatialindex/spatialindex-src-1.7.1.tar.gz'
  sha1 '1c08fe9e25679b26bf4d26dddf4bbc2e828a35e9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
