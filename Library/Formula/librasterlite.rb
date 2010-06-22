require 'formula'

class Librasterlite <Formula
  url 'http://www.gaia-gis.it/spatialite/librasterlite-1.0.tar.gz'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 'c6f7864ac6101ff63f8aec4b02603b46'

  depends_on "libgeotiff"
  depends_on "libspatialite"

  def install
    # For PNG support
    ENV.x11
    system "./configure", "--disable-debug", 
                          "--disable-dependency-tracking", 
                          "--prefix=#{prefix}"
    system "make install"
  end
end
