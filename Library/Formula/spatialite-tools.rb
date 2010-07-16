require 'formula'

class SpatialiteTools <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0/spatialite-tools-2.4.0.tar.gz'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 'ea508c0d7c7a58d4b75fe82ee62d8591'

  depends_on 'libspatialite'

  def install
    system "./configure", "--prefix=#{prefix}", 
                          "--disable-debug",
                          "--target=macosx",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
