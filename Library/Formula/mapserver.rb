require 'formula'

class Mapserver < Formula
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.0.3.tar.gz'
  sha1 'd7aa1041c6d9a46da7f5e29ae1b66639d5d050ab'

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  depends_on :freetype
  depends_on :libpng
  depends_on 'giflib'
  depends_on 'gd'
  depends_on 'proj'
  depends_on 'gdal'

  depends_on 'geos' if build.include? 'with-geos'
  depends_on 'postgresql' if build.include? 'with-postgresql' and not MacOS.lion?
  depends_on 'fcgi' if build.include? 'with-fastcgi'

  def patches
    # Fix clang compilation issue, remove on future release
    # See http://trac.osgeo.org/mapserver/changeset/12809
    # Fix msGetMarkerSize() called on unloaded pixmap symbol
    # https://github.com/mapserver/mapserver/issues/4225
    DATA
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-gdal",
      "--with-ogr",
    ]

    args << "--with-geos" if build.include? 'with-geos'
    args << "--with-php=/usr/include/php" if build.include? 'with-php'

    if build.include? 'with-postgresql'
      if MacOS.lion? # Lion ships with PostgreSQL libs
        args << "--with-postgis"
      else
        args << "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    args << "--with-fastcgi=#{HOMEBREW_PREFIX}" if build.include? 'with-fastcgi'

    system "./configure", *args
    system "make"
    libexec.install "mapscriptvars"
    bin.install %w(mapserv shp2img legend shptree shptreevis
        shptreetst scalebar sortshp tile4ms
        msencrypt mapserver-config)

    if build.include? 'with-php'
      prefix.install %w(mapscript/php/php_mapscript.so)
    end
  end

  def caveats; <<-EOS.undent
    The Mapserver CGI executable is #{bin}/mapserv

    If you built the PHP option:
      * Add the following line to php.ini:
        extension="#{prefix}/php_mapscript.so"
      * Execute "php -m"
      * You should see MapScript in the module list
    EOS
  end

  def test
    system "#{bin}/mapserver-config", "--version"
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
diff --git a/mapsymbol.c b/mapsymbol.c
index 164a0ac..f9dcb20 100644
--- a/mapsymbol.c
+++ b/mapsymbol.c
@@ -601,6 +601,10 @@ int msGetMarkerSize(symbolSetObj *symbolset, styleObj *style, int *width, int *h
   }

   symbol = symbolset->symbol[style->symbol];
+  if (symbol->type == MS_SYMBOL_PIXMAP && !symbol->pixmap_buffer) {
+    if (MS_SUCCESS != msPreloadImageSymbol(MS_MAP_RENDERER(symbolset->map), symbol))
+        return MS_FAILURE;
+  }
   if(style->size == -1) {
       size = MS_NINT( msSymbolGetDefaultSize(symbol) * scalefactor );
   }
