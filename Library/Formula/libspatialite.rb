require 'formula'

class Libspatialite < Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0-5/libspatialite-amalgamation-2.4.0.tar.gz'
  version '2.4.0-rc5'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 '33f8db72f4b6d863a2e0f4b2bed31a74'

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
