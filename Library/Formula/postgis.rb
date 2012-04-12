require 'formula'

def build_gui?
  ARGV.include? '--with-gui'
end

class Postgis < Formula
  homepage 'http://postgis.refractions.net'
  url 'http://postgis.org/download/postgis-2.0.0.tar.gz'
  md5 '639d2b5d6a7dc94ea2e60d6942a615bc'

  head 'http://svn.osgeo.org/postgis/trunk/', :using => :svn

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'

  depends_on 'gtk+' if build_gui?

  # For GeoJSON and raster handling
  depends_on 'json-c'
  depends_on 'gdal'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [
      ['--with-gui', 'Build shp2pgsql-gui in addition to command line tools']
    ]
  end

  # PostGIS command line tools intentionally have unused symbols in
  # them---these are callbacks for liblwgeom.
  skip_clean :all

  def install
    ENV.deparallelize
    postgresql = Formula.factory 'postgresql'
    jsonc   = Formula.factory 'json-c'

    args = [
      "--disable-dependency-tracking",
      # Can't use --prefix, PostGIS disrespects it and flat-out refuses to
      # accept it with 2.0.
      "--with-projdir=#{HOMEBREW_PREFIX}",
      "--with-jsondir=#{jsonc.prefix}",
      # This is against Homebrew guidelines, but we have to do it as the
      # PostGIS plugin libraries can only be properly inserted into Homebrew's
      # Postgresql keg.
      "--with-pgconfig=#{postgresql.bin}/pg_config",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of it's compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls"
    ]
    args << '--with-gui' if build_gui?


    system './autogen.sh' if ARGV.build_head?
    system './configure', *args
    system 'make'

    # __DON'T RUN MAKE INSTALL!__
    #
    # PostGIS includes the PGXS makefiles and so will install __everything__
    # into the Postgres keg instead of the PostGIS keg. Unfortunately, some
    # things have to be inside the Postgres keg in order to be function. So, we
    # install the bare minimum of stuff and then manually move everything else
    # to the prefix.

    # Install PostGIS plugin libraries into the Postgres keg so that they can
    # be loaded and so PostGIS databases will continue to function even if
    # PostGIS is removed.
    postgresql.lib.install Dir['postgis/postgis*.so']

    # Stand-alone SQL files will be installed the share folder
    postgis_sql = share + 'postgis'

    # Install version-specific SQL scripts and tools first. Some of the
    # installation routines require command line tools to still be present
    # inside the build prefix.

    # Install the liblwgeom library
    lib.install Dir['liblwgeom/.libs/*.dylib', 'liblwgeom/.libs/*.a']
    include.install 'liblwgeom/liblwgeom.h'

    # Install raster plugin to Postgres keg
    postgresql.lib.install Dir['raster/rt_pg/rtpostgis*.so']

    # Install extension scripts to the Postgres keg.
    # `CREATE EXTENSION postgis;` won't work if these are located elsewhere.
    system 'make install -C extensions'

    bin.install %w[
      loader/.libs/pgsql2shp
      loader/.libs/shp2pgsql
      raster/loader/.libs/raster2pgsql
    ]
    bin.install 'loader/.libs/shp2pgsql-gui' if build_gui?

    # Install PostGIS 2.0 SQL scripts
    postgis_sql.install %w[
      postgis/legacy.sql
      postgis/legacy_minimal.sql
      postgis/uninstall_legacy.sql
      postgis/postgis_upgrade_20_minor.sql
    ]

    postgis_sql.install %w[
      raster/rt_pg/rtpostgis.sql
      raster/rt_pg/rtpostgis_drop.sql
      raster/rt_pg/rtpostgis_upgrade_20_minor.sql
      raster/rt_pg/rtpostgis_upgrade.sql
      raster/rt_pg/rtpostgis_upgrade_cleanup.sql
      raster/rt_pg/uninstall_rtpostgis.sql
    ]

    postgis_sql.install %w[
      topology/topology.sql
      topology/topology_upgrade_20_minor.sql
      topology/uninstall_topology.sql
    ]

    # Common tools
    bin.install %w[
      utils/create_undef.pl
      utils/postgis_proc_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]

    # Common SQL scripts
    postgis_sql.install %w[
      spatial_ref_sys.sql
      postgis/postgis.sql
      postgis/uninstall_postgis.sql
    ]
  end

  def caveats;
    postgresql = Formula.factory 'postgresql'

    <<-EOS.undent
      To create a spatially-enabled database, see the documentation:
        http://postgis.refractions.net/documentation/manual-1.5/ch02.html#id2630392
      and to upgrade your existing spatial databases, see here:
        http://postgis.refractions.net/documentation/manual-1.5/ch02.html#upgrading

      PostGIS SQL scripts installed to:
        #{HOMEBREW_PREFIX}/share/postgis
      PostGIS plugin libraries installed to:
        #{postgresql.lib}
      PostGIS extension modules installed to:
        #{postgresql.share}/postgresql/extension
    EOS
  end
end
