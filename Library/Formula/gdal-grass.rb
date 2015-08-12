class GdalGrass < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "http://www.gdal.org"
  url "http://download.osgeo.org/gdal/gdal-grass-1.4.3.tar.gz"
  sha256 "ea18d1e773e8875aaf3261a6ccd2a5fa22d998f064196399dfe73d991688f1dd"
  revision 1

  depends_on "gdal"
  depends_on "grass"

  # https://trac.osgeo.org/grass/ticket/2724
  patch :DATA

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

__END__
--- a/ogrgrass.h	2015-08-13 16:46:46.000000000 +0200
+++ b/ogrgrass.h	2015-08-13 16:46:44.000000000 +0200
@@ -51,7 +51,7 @@
 
     // Layer info
     OGRFeatureDefn *    GetLayerDefn() { return poFeatureDefn; }
-    int                 GetFeatureCount( int );
+    GIntBig                 GetFeatureCount( int );
     OGRErr              GetExtent(OGREnvelope *psExtent, int bForce);
     virtual OGRSpatialReference *GetSpatialRef();
     int                 TestCapability( const char * );
--- a/ogrgrasslayer.cpp	2015-08-13 16:46:36.000000000 +0200
+++ b/ogrgrasslayer.cpp	2015-08-13 16:46:32.000000000 +0200
@@ -982,7 +982,7 @@
 /*      Eventually we should consider implementing a more efficient     */
 /*      way of counting features matching a spatial query.              */
 /************************************************************************/
-int OGRGRASSLayer::GetFeatureCount( int bForce )
+GIntBig OGRGRASSLayer::GetFeatureCount( int bForce )
 {
     if( m_poFilterGeom != NULL || m_poAttrQuery != NULL )
         return OGRLayer::GetFeatureCount( bForce );

