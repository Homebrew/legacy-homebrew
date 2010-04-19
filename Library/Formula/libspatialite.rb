require 'formula'

class InitSpatialite <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0/init_spatialite-2.4.sql.zip'
  md5 '06c740cade77217844c99c25ecc2ac39'
end

class Libspatialite <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0/libspatialite-amalgamation-2.4.0.tar.gz'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 '9519c71b80037efccde02e046342f239'

  depends_on 'proj'
  depends_on 'geos'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=macosx"
    system "make install"
    
    InitSpatialite.new.brew do
      (share+'spatialite').install 'init_spatialite-2.4.sql'
    end
  end
end
