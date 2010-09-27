require 'formula'

class Postgis <Formula
  url 'http://postgis.refractions.net/download/postgis-1.5.2.tar.gz'
  homepage 'http://postgis.refractions.net/'
  md5 '772ec1d0f04d6800cd7e2420a97a7483'

  head 'http://svn.osgeo.org/postgis/trunk/', :using => :svn

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'

  def install
    ENV.deparallelize
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-projdir=#{HOMEBREW_PREFIX}"
    system "make install"

    # Copy some of the generated files to the share folder
    (share+'postgis').install %w(
      spatial_ref_sys.sql postgis/postgis.sql
      postgis/postgis_upgrade_13_to_15.sql
      postgis/postgis_upgrade_14_to_15.sql
      postgis/postgis_upgrade_15_minor.sql postgis/uninstall_postgis.sql
    )
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
