require 'formula'

class Spatialindex <Formula
  url 'http://download.osgeo.org/libspatialindex/spatialindex-src-1.5.0.tar.gz'
  homepage 'http://trac.gispython.org/spatialindex/'
  md5 '5d409794d860505b93f8935d98a6d173'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
