# Includes postgis 2.0 support

require 'formula'

def raster?
  ARGV.include? '--with-raster'
end

def topology?
  ARGV.include? '--with-topology'
end

class Postgis < Formula
  url 'http://postgis.refractions.net/download/postgis-1.5.3.tar.gz'
  homepage 'http://postgis.refractions.net/'
  md5 '05a61df5e1b78bf51c9ce98bea5526fc'
  head 'http://svn.osgeo.org/postgis/trunk/', :using => :svn

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'
  depends_on 'gdal' if raster?

  # For libintl and GeoJSON handling
  if ARGV.build_head?
    depends_on 'gettext' 
    depends_on 'json-c'
  end  

  def options
    [
      ['--with-raster',   'Enable PostGIS Raster extension (HEAD builds only).'  ],
      ['--with-topology', 'Enable PostGIS Topology extension (HEAD builds only).']
    ]
  end

  def install
    ENV.deparallelize

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-projdir=#{HOMEBREW_PREFIX}"
    ]

    # Apple ships a postgres client in Lion, conflicts with installed PostgreSQL server.
    if MacOS.lion?
      postgresql = Formula.factory 'postgresql'
      args << "--with-pgconfig=#{postgresql.bin}/pg_config"
    end

    if ARGV.build_head?
      system "./autogen.sh"
      gettext = Formula.factory 'gettext'
      jsonc   = Formula.factory 'json-c'
      args << "--with-gettext=#{gettext.prefix}"
      args << "--with-jsondir=#{jsonc.prefix}"
      args << "--with-raster"   if raster?
      args << "--with-topology" if topology?
    end

    system "./configure", *args
    system "make install"

    # Copy generated SQL files to the share folder
    postgis_sql = share + 'postgis'
    
    # Install common SQL scripts
    postgis_sql.install %w[
      spatial_ref_sys.sql 
      postgis/postgis.sql 
      postgis/uninstall_postgis.sql
    ]

    # Be explicit about requirements for 2.0 and 1.5.x series PostGIS, even if a little non-DRY.
    if ARGV.build_head?
      # Install PostGIS 2.0 SQL scripts
      postgis_sql.install %w[
        postgis/legacy.sql 
        postgis/legacy_compatibility_layer.sql 
        postgis/uninstall_legacy.sql
        postgis/postgis_upgrade_20_minor.sql
      ]
      
      # Copy utils scripts and SQL to PostGIS Cellar for convenience
      #
      # SQL and scripts
      # also in /usr/local/Cellar/postgresql/9.1.2/share/postgresql/contrib/postgis-2.0
      #
      # IMPORTANT: shp2pgsql, pgsql2shp and raster2pgsql
      # Found in /usr/local/Cellar/postgresql/9.1.x/bin and need to be symlinked not moved  
                
      bin.install %w[
        utils/create_undef.pl      
        utils/postgis_proc_upgrade.pl
        utils/postgis_restore.pl
        utils/profile_intersects.pl
        utils/read_scripts_version.pl
        utils/test_estimation.pl
        utils/test_geography_estimation.pl
        utils/test_geography_joinestimation.pl
        utils/test_joinestimation.pl        
      ]      
            
      if raster?
        postgis_sql.install %w[
          raster/rt_pg/rtpostgis.sql 
          raster/rt_pg/rtpostgis_drop.sql 
          raster/rt_pg/rtpostgis_upgrade_20_minor.sql 
          raster/rt_pg/rtpostgis_upgrade.sql
          raster/rt_pg/rtpostgis_upgrade_cleanup.sql 
        ]         
      end
      
      if topology?
        postgis_sql.install %w[
          topology/topology.sql
          topology/topology_upgrade_20_minor.sql
        ] 
      end  
    else
      # Install PostGIS 1.x upgrade scripts
      postgis_sql.install %w[
        postgis/postgis_upgrade_13_to_15.sql
        postgis/postgis_upgrade_14_to_15.sql
        postgis/postgis_upgrade_15_minor.sql
      ]
      
      # Copy loader and utils binaries to bin folder
      bin.install %w[
        loader/pgsql2shp         
        loader/shp2pgsql 
        utils/create_undef.pl
        utils/new_postgis_restore.pl 
        utils/postgis_proc_upgrade.pl
        utils/postgis_restore.pl 
        utils/profile_intersects.pl
        utils/test_estimation.pl 
        utils/test_joinestimation.pl
      ]      
    end
  end

  def caveats; <<-EOS.undent
    To create a spatially-enabled database, see the documentation:
      http://postgis.refractions.net/documentation/manual-1.5/ch02.html#id2630392
    and to upgrade your existing spatial databases, see here:
      http://postgis.refractions.net/documentation/manual-1.5/ch02.html#upgrading
    IMPORTANT: If installing HEAD, shp2pgsql, pgsql2shp and raster2pgsql will be found in 
      /usr/local/Cellar/postgresql/9.1.x/bin and need to be re-linked
    EOS
  end
end
