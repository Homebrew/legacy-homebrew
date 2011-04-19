require 'formula'

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.4.tar.gz'
  md5 'f3a1afa9218386b50ffd262c00b35b31'
end

class Poppler < Formula
  url 'http://poppler.freedesktop.org/poppler-0.16.3.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '42227f1a1498089213a07533596b22f4'

  depends_on 'pkg-config' => :build
  depends_on "qt" if ARGV.include? "--with-qt4"

  def patches
    DATA
  end

  def options
    [
      ["--with-qt4", "Include Qt4 support (which compiles all of Qt4!)"],
      ["--enable-xpdf-headers", "Also install XPDF headers."]
    ]
  end

  def install
    if ARGV.include? "--with-qt4"
      qt4Flags = `pkg-config QtCore --libs` + `pkg-config QtGui --libs`
      qt4Flags.gsub!("\n","")
      ENV['POPPLER_QT4_CFLAGS'] = qt4Flags
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--disable-poppler-qt4" unless ARGV.include? "--with-qt4"
    args << "--enable-xpdf-headers" if ARGV.include? "--enable-xpdf-headers"

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end

# fix location of fontconfig, http://www.mail-archive.com/poppler@lists.freedesktop.org/msg03837.html
__END__
--- a/cpp/Makefile.in	2010-07-08 20:57:56.000000000 +0200
+++ b/cpp/Makefile.in	2010-08-06 11:11:27.000000000 +0200
@@ -375,7 +375,8 @@
 INCLUDES = \
 	-I$(top_srcdir)				\
 	-I$(top_srcdir)/goo			\
-	-I$(top_srcdir)/poppler
+	-I$(top_srcdir)/poppler \
+	$(FONTCONFIG_CFLAGS)
 
 SUBDIRS = . tests
 poppler_includedir = $(includedir)/poppler/cpp
