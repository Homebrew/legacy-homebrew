require 'formula'

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.1.0.tar.gz'
  sha1 '33b45f3d00f6ba633c6e4d95387336e132a1d2e3'

  option 'without-freexl', 'Build without support for reading Excel files'
  option 'with-postgis', 'Enable additional sanitization/segmentation routines provided by PostGIS 2.0+'

  depends_on 'proj'
  depends_on 'geos'
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on 'sqlite'

  depends_on 'freexl' => :recommended
  depends_on 'postgis' => :optional

  def install
    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula.factory 'sqlite'
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_prefix}/lib"
    ENV.append 'CFLAGS', "-I#{sqlite.opt_prefix}/include"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
    ]
    args << '--enable-freexl=no' if build.without? 'freexl'
    args << '--enable-lwgeom' if build.with? 'lwgeom'

    system './configure', *args
    system "make install"
  end

end
