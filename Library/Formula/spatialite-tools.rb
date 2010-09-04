require 'formula'

class SpatialiteTools <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0-3/spatialite-tools-2.4.0.tar.gz'
  version '2.4.0-rc3a'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 '786b36b431142bfaca2a88bf23f7787c'

  depends_on 'libspatialite'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=macosx"
    system "make install"
  end
end
