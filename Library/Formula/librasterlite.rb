require 'formula'

class Librasterlite < Formula
  homepage 'https://www.gaia-gis.it/fossil/librasterlite/index'
  url 'http://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1e.tar.gz'
  sha1 'ac6d15e20aa02553b6a37cf36ebbea4b0c45a881'

  depends_on "pkg-config" => :build
  depends_on :libpng
  depends_on "libgeotiff"
  depends_on "libspatialite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula.factory 'sqlite'
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_prefix}/lib"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
