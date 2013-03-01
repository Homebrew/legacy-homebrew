require 'formula'

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-3.0.1.tar.gz'
  sha1 'a88c763302aabc3b74d44a88f969c8475f0c0d10'

  devel do
    url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.0.0.tar.gz'
    sha1 '3d20fcabcc5a951e7863d33b6b6ef3f78dbf006d'
  end

  option 'without-freexl', 'Build without support for reading Excel files'
  option 'with-lwgeom', 'Enable additional sanitization/segmentation routines provided by PostGIS 2.0+. (--devel builds only)'

  depends_on 'proj'
  depends_on 'geos'
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on 'sqlite'

  depends_on 'freexl' unless build.include? 'without-freexl'
  depends_on 'postgis' if build.include? 'with-lwgeom' and build.devel?

  def install
    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula.factory 'sqlite'
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_prefix}/lib"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
    ]
    args << '--enable-freexl=no' if build.include? 'without-freexl'
    args << '--enable-lwgeom' if build.include? 'with-lwgeom' and build.devel?

    system './configure', *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    Note that the SpatiaLite 4.x series is not compatible with QGIS 1.8.0 or
    GDAL 1.9.2. Hopefully this situation will improve in future releases.
    EOS
  end if build.devel?

end
