require 'formula'

class Librasterlite < Formula
  homepage 'https://www.gaia-gis.it/fossil/librasterlite/index'
  url 'http://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1c.tar.gz'
  sha1 'c54f38ef2974bc92410e2c2196088af14bd9c21a'

  depends_on "libgeotiff"
  depends_on "libspatialite"

  def install
    ENV.x11 # For image format libraries
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
