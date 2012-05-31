require 'formula'

class Librasterlite < Formula
  homepage 'https://www.gaia-gis.it/fossil/librasterlite/index'
  url 'http://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1b.tar.gz'
  md5 '3100a552fa776ad1124ba00657760dea'

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
