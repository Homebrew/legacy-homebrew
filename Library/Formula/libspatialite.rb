require 'formula'

class Libspatialite <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0-4/libspatialite-amalgamation-2.4.0.tar.gz'
  version '2.4.0-rc4'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 'e8c863d55766055564b44e606f2be51d'

  depends_on 'proj'
  depends_on 'geos'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=macosx"
    system "make install"
  end
end
