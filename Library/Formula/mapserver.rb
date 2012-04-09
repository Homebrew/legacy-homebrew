require 'formula'

class Mapserver < Formula
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.0.2.tar.gz'
  md5 'd831c905b1b0df7ac09a80c3f9387374'
  head 'https://github.com/mapserver/mapserver.git'

  depends_on 'gd' if not ARGV.build_head?
  depends_on 'proj'
  depends_on 'jpeg'

  #we want gdal support if ogr was requested, unless gdal was explicitely disabled
  depends_on 'gdal' if ARGV.include? '--with-ogr' or not ARGV.include? '--without-gdal'

  depends_on 'geos' if ARGV.include? '--with-geos'
  depends_on 'giflib' if not ARGV.build_head? or ARGV.include? '--with-gif'
  depends_on 'cairo' if ARGV.include? '--with-cairo'

  #postgis support enabled by default
  depends_on 'postgresql' if not MacOS.lion? and not ARGV.include? '--without-postgresql'

  def options
    [
      ["--with-gd", "Build support for the aging GD renderer"],
      ["--with-ogr", "Build support for OGR vector access"],
      ["--with-geos", "Build support for GEOS spatial operations"],
      ["--with-php", "Build PHP MapScript module"],
      ["--with-gif", "Enable support for gif symbols"],
      ["--with-cairo", "Enable support for cairo SVG and PDF output"],
      ["--without-postgresql", "Disable support for PostgreSQL as a data source"],
      ["--without-gdal", "Disable support for GDAL raster access"]
    ]
  end

  def configure_args
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-png=/usr/X11"
    ]

    args.push "--with-gd" if ARGV.include? '--with-gd' or not ARGV.build_head?
    args.push "--with-gdal" unless ARGV.include? '--without-gdal'
    args.push "--without-gif" if ARGV.build_head? and not ARGV.include? '--with-gif'
    args.push "--with-ogr" if ARGV.include? '--with-ogr'
    args.push "--with-geos" if ARGV.include? '--with-geos'
    args.push "--with-cairo" if ARGV.include? '--with-cairo'
    args.push "--with-php=/usr/include/php" if ARGV.include? '--with-php'

    unless ARGV.include? '--without-postgresql'
      if MacOS.lion? # Lion ships with PostgreSQL libs
        args.push "--with-postgis"
      else
        args.push "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    args
  end

  def patches
    # Fix clang compilation issue, remove on future release
    # See http://trac.osgeo.org/mapserver/changeset/12809
    DATA if not ARGV.build_head?
  end

  def install
    ENV.x11
    system "./configure", *configure_args
    system "make"
    if not ARGV.build_head?
      bin.install %w(mapserv shp2img legend shptree shptreevis
        shptreetst scalebar sortshp mapscriptvars tile4ms
        msencrypt mapserver-config)
    else
      system "make install"
    end
         

    if ARGV.include? '--with-php'
      prefix.install %w(mapscript/php/php_mapscript.so)
    end
  end

  def caveats
    s = <<-EOS
The Mapserver CGI executable is #{prefix}/mapserv
    EOS
    if ARGV.include? '--with-php'
      s << <<-EOS
If you built the PHP option:
  * Add the following line to php.ini:
    extension="#{prefix}/php_mapscript.so"
  * Execute "php -m"
  * You should see MapScript in the module list
      EOS
    end
    return s
  end
end

__END__
diff --git a/renderers/agg/include/agg_renderer_outline_aa.h b/renderers/agg/include/agg_renderer_outline_aa.h
index 5ff3f20..7a14588 100644
--- a/renderers/agg/include/agg_renderer_outline_aa.h
+++ b/renderers/agg/include/agg_renderer_outline_aa.h
@@ -1365,7 +1365,6 @@ namespace mapserver
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }

         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
