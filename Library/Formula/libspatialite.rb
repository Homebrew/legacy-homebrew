require 'formula'

class Libspatialite <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0-3/libspatialite-amalgamation-2.4.0.tar.gz'
  version '2.4.0-rc3a'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 '19d870bd4e0ec2f095a5703b9ef4eaef'

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
