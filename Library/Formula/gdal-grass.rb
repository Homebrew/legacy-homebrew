require 'formula'

class GdalGrass < Formula
  homepage 'http://www.gdal.org'
  url 'http://download.osgeo.org/gdal/gdal-grass-1.4.3.tar.gz'
  md5 '2bfb7640e03b4d9d012f1a5d62c0351d'

  depends_on 'gdal'
  depends_on 'grass'

  def install
    grass = Formula.factory('grass')

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-gdal=#{HOMEBREW_PREFIX}/bin/gdal-config",
                          "--with-grass=#{grass.prefix}/grass-#{grass.version}",
                          "--with-autoload=#{lib}/gdalplugins"

    inreplace "Makefile", 'mkdir', 'mkdir -p'

    system "make install"
  end

  def caveats
    caveats = <<-EOS
This formula provides a plugin that allows GDAL and OGR to access geospatial
data stored using the GRASS vector and raster formats. In order to use the
plugin, you will need to add the following path to the GDAL_DRIVER_PATH
enviroment variable:
    #{HOMEBREW_PREFIX}/lib/gdalplugins
    EOS
  end
end
