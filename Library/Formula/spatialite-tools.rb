require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-3.1.0b.tar.gz'
  sha1 '82d40a4ef92d86a310e07f0e7e43372904bdbba9'

  devel do
    url 'http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.0.0-RC1.tar.gz'
    sha1 'fa9c60b2c993ef22c5618261c13cc3cdcbad223b'
  end

  depends_on 'pkg-config' => :build

  depends_on 'libspatialite'
  depends_on 'readosm'

  def install
    # See: https://github.com/mxcl/homebrew/issues/3328
    ENV.append 'LDFLAGS', '-liconv'
    # Ensure Homebrew SQLite is found before system SQLite.
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
