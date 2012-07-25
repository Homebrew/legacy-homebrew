require 'formula'

def build_gui?
  ARGV.include? '--with-gui'
end

class Postgis < Formula
  homepage 'http://postgis.refractions.net'
  url 'http://postgis.org/download/postgis-2.0.1.tar.gz'
  sha1 '31db797a835f14470f9e1183fe8fd2ba7b99aadf'

  head 'http://svn.osgeo.org/postgis/trunk/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'

  depends_on 'gtk+' if build_gui?

  # For GeoJSON and raster handling
  depends_on 'json-c'
  depends_on 'gdal'

  def options
    [
      ['--with-gui', 'Build shp2pgsql-gui in addition to command line tools']
    ]
  end

  # PostGIS command line tools intentionally have unused symbols in
  # them---these are callbacks for liblwgeom.
  skip_clean :all

  def postgresql
    # Follow the PostgreSQL linked keg back to the active Postgres installation
    # as it is common for people to avoid upgrading Postgres.
    Formula.factory('postgresql').linked_keg.realpath
  end

  def install
    ENV.deparallelize
    jsonc   = Formula.factory 'json-c'

    args = [
      "--disable-dependency-tracking",
      # Can't use --prefix, PostGIS disrespects it and flat-out refuses to
      # accept it with 2.0.
      "--with-projdir=#{HOMEBREW_PREFIX}",
      "--with-jsondir=#{jsonc.linked_keg.realpath}",
      # This is against Homebrew guidelines, but we have to do it as the
      # PostGIS plugin libraries can only be properly inserted into Homebrew's
      # Postgresql keg.
      "--with-pgconfig=#{postgresql}/bin/pg_config",
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

    # PostGIS includes the PGXS makefiles and so will install __everything__
    # into the Postgres keg instead of the PostGIS keg. Unfortunately, some
    # things have to be inside the Postgres keg in order to be function. So, we
    # install everything to a staging directory and manually move the pieces
    # into the appropriate prefixes.
    mkdir 'stage'
    system 'make', 'install', "DESTDIR=#{buildpath}/stage"

    # Install PostGIS plugin libraries into the Postgres keg so that they can
    # be loaded and so PostGIS databases will continue to function even if
    # PostGIS is removed.
    (postgresql/'lib').install Dir['stage/**/*.so']

    # Install extension scripts to the Postgres keg.
    # `CREATE EXTENSION postgis;` won't work if these are located elsewhere.
    (postgresql/'share/postgresql/extension').install Dir['stage/**/extension/*']

    bin.install Dir['stage/**/bin/*']
    lib.install Dir['stage/**/lib/*']
    include.install Dir['stage/**/include/*']

    # Stand-alone SQL files will be installed the share folder
    (share + 'postgis').install Dir['stage/**/contrib/postgis-2.0/*']

    # Extension scripts
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

    man1.install Dir['doc/**/*.1']
  end

  def caveats;
    <<-EOS.undent
      To create a spatially-enabled database, see the documentation:
        http://postgis.refractions.net/documentation/manual-2.0/postgis_installation.html#create_new_db_extensions
      and to upgrade your existing spatial databases, see here:
        http://postgis.refractions.net/documentation/manual-2.0/postgis_installation.html#upgrading

      PostGIS SQL scripts installed to:
        #{HOMEBREW_PREFIX}/share/postgis
      PostGIS plugin libraries installed to:
        #{postgresql}/lib
      PostGIS extension modules installed to:
        #{postgresql}/share/postgresql/extension
      EOS
  end
end
