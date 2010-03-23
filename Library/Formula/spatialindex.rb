require 'formula'

class Spatialindex <Formula
  url 'http://download.osgeo.org/libspatialindex/spatialindex-1.4.0.tar.gz'
  homepage 'http://trac.gispython.org/spatialindex/'
  md5 '2cda512ca12c1a0d52172bb7f82a88f0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
