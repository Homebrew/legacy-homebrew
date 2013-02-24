require 'formula'

class Pdf2svg < Formula
  homepage 'http://www.cityinthesky.co.uk/opensource/pdf2svg'
  url 'http://www.cityinthesky.co.uk/_media/opensource/pdf2svg-0.2.1.tar.gz'
  sha1 '12f9d1bde6aa2e396eb7f196b6d8e29ade3cafe6'

  depends_on "pkg-config" => :build

  depends_on :x11
  depends_on "poppler" => "with-glib"
  depends_on "gtk+"
  depends_on "cairo" # Poppler-glib needs a newer cairo than provided by OS X 10.6.x
                     # and pdf2svg needs it to be on PKG_CONFIG_PATH during the build
  def patches
    # fix call to poppler to render normal thickness lines in firefox
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- pdf2svg-0.2.1/pdf2svg.c.ORIG        2008-02-01 10:28:35.000000000 -0800
+++ pdf2svg-0.2.1/pdf2svg.c     2011-11-26 03:56:15.000000000 -0800
@@ -65,7 +65,7 @@
     drawcontext = cairo_create(surface);
 
     // Render the PDF file into the SVG file
-    poppler_page_render(page, drawcontext);
+    poppler_page_render_for_printing(page, drawcontext);
     cairo_show_page(drawcontext);
 
     // Close the SVG file
