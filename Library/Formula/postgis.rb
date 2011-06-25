require 'formula'

def raster?
  ARGV.include? '--with-raster'
end

def topology?
  ARGV.include? '--with-topology'
end

class Postgis < Formula
  url 'http://postgis.refractions.net/download/postgis-1.5.2.tar.gz'
  homepage 'http://postgis.refractions.net/'
  md5 '772ec1d0f04d6800cd7e2420a97a7483'

  head 'http://svn.osgeo.org/postgis/trunk/', :using => :svn

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'
  depends_on 'gdal' if raster?

  # For libintl
  depends_on 'gettext' if ARGV.build_head?

  def options
    [
      ['--with-raster', 'Enable PostGIS Raster extension (HEAD builds only).'],
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

    if ARGV.build_head?
      system "./autogen.sh"
      gettext = Formula.factory('gettext')
      args << "--with-gettext=#{gettext.prefix}"
      args << "--with-raster" if raster?
      args << "--with-topology" if topology?
    end

    system "./configure", *args
    system "make install"

    # Copy some of the generated files to the share folder
    (share+'postgis').install %w(
      spatial_ref_sys.sql postgis/postgis.sql
      postgis/postgis_upgrade_13_to_15.sql
      postgis/postgis_upgrade_14_to_15.sql
      postgis/postgis_upgrade_15_minor.sql postgis/uninstall_postgis.sql
    )

    if ARGV.build_head?
      (share+'postgis').install 'raster/rt_pg/rtpostgis.sql' if raster?
      (share+'postgis').install 'topology/topology.sql' if topology?
    end

    # Copy loader and utils binaries to bin folder
    bin.install %w(
      loader/pgsql2shp loader/shp2pgsql utils/create_undef.pl
      utils/new_postgis_restore.pl utils/postgis_proc_upgrade.pl
      utils/postgis_restore.pl utils/profile_intersects.pl
    )
  end

  def caveats; <<-EOS.undent
    To create a spatially-enabled database, see the documentation:
      http://postgis.refractions.net/documentation/manual-1.5.2/ch02.html#id2786223
    EOS
  end
end
