require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.1.0.tar.gz'
  sha1 '8c5edbed7e3326a679b336532e0add313b2af8b5'

  depends_on 'pkg-config' => :build

  depends_on 'libspatialite'
  depends_on 'readosm'

  def install
    # See: https://github.com/mxcl/homebrew/issues/3328
    ENV.append 'LDFLAGS', '-liconv'
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula.factory 'sqlite'
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_prefix}/lib"
    ENV.append 'CFLAGS', "-I#{sqlite.opt_prefix}/include"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
