require 'formula'

class Spatialindex < Formula
  url 'http://download.osgeo.org/libspatialindex/spatialindex-src-1.6.1.tar.gz'
  homepage 'http://trac.gispython.org/spatialindex/'
  md5 '13fc1c339805ca34156d9defd1a97629'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
