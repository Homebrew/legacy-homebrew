require 'formula'

class Mapserver < Formula
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.0.2.tar.gz'
  md5 'd831c905b1b0df7ac09a80c3f9387374'

  depends_on :x11
  depends_on 'gd'
  depends_on 'proj'
  depends_on 'gdal'

  depends_on 'geos' if ARGV.include? '--with-geos'
  depends_on 'postgresql' if ARGV.include? '--with-postgresql' and not MacOS.lion?
  depends_on 'fcgi' if ARGV.include? '--with-fastcgi'

  def options
    [
      ["--with-fastcgi", "Build with fastcgi support"],
      ["--with-geos", "Build support for GEOS spatial operations"],
      ["--with-php", "Build PHP MapScript module"],
      ["--with-postgresql", "Build support for PostgreSQL as a data source"]
    ]
  end

  def configure_args
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-gdal",
      "--with-ogr",
      "--with-png=#{MacOS.x11_prefix}"
    ]

    args.push "--with-geos" if ARGV.include? '--with-geos'
    args.push "--with-php=/usr/include/php" if ARGV.include? '--with-php'

    if ARGV.include? '--with-postgresql'
      if MacOS.lion? # Lion ships with PostgreSQL libs
        args.push "--with-postgis"
      else
        args.push "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    if ARGV.include? '--with-fastcgi'
      args.push "--with-fastcgi=#{HOMEBREW_PREFIX}"
    end

    args
  end

  def patches
    # Fix clang compilation issue, remove on future release
    # See http://trac.osgeo.org/mapserver/changeset/12809
    DATA
  end

  def install
    system "./configure", *configure_args
    system "make"
    bin.install %w(mapserv shp2img legend shptree shptreevis
        shptreetst scalebar sortshp mapscriptvars tile4ms
        msencrypt mapserver-config)

    if ARGV.include? '--with-php'
      prefix.install %w(mapscript/php/php_mapscript.so)
    end
  end

  def caveats; <<-EOS.undent
    The Mapserver CGI executable is #{prefix}/mapserv

    If you built the PHP option:
      * Add the following line to php.ini:
        extension="#{prefix}/php_mapscript.so"
      * Execute "php -m"
      * You should see MapScript in the module list
    EOS
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
