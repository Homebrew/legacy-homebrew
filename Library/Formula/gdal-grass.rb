class GdalGrass < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "http://www.gdal.org"
  url "http://download.osgeo.org/gdal/gdal-grass-1.4.3.tar.gz"
  sha256 "ea18d1e773e8875aaf3261a6ccd2a5fa22d998f064196399dfe73d991688f1dd"

  depends_on "gdal"
  depends_on "grass"

  def install
    gdal = Formula["gdal"]
    grass = Formula["grass"]

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-gdal=#{gdal.bin}/gdal-config",
                          "--with-grass=#{grass.opt_prefix}/grass-#{grass.version}",
                          "--with-autoload=#{lib}/gdalplugins"

    inreplace "Makefile", "mkdir", "mkdir -p"

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This formula provides a plugin that allows GDAL and OGR to access geospatial
    data stored using the GRASS vector and raster formats. In order to use the
    plugin, you will need to add the following path to the GDAL_DRIVER_PATH
    enviroment variable:
      #{HOMEBREW_PREFIX}/lib/gdalplugins
    EOS
  end
end
