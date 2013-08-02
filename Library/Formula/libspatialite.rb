require 'formula'

# Postgis depends on gdal, which in turn depends on libspatialite,
# so enabling a "with-postgis" option in this formula introduces a
# circular dependency.
# See https://github.com/mxcl/homebrew/issues/20373

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.1.1.tar.gz'
  sha1 'b8ed50fb66c4a898867cdf9d724d524c5e27e8aa'

  option 'without-freexl', 'Build without support for reading Excel files'
  option 'without-libxml2', 'Disable support for xml parsing (parsing needed by spatialite-gui)'

  depends_on 'pkg-config' => :build
  depends_on 'proj'
  depends_on 'geos'
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on 'sqlite'
  depends_on 'libxml2' => :recommended
  depends_on 'freexl' => :recommended

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
    args << '--enable-libxml2=yes' unless build.without? 'libxml2'

    system './configure', *args
    system "make install"
  end

end
