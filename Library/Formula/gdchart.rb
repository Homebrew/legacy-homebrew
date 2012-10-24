require 'formula'

class Gdchart < Formula
  homepage 'http://www.fred.net/brv/chart/'
  url 'http://www.fred.net/brv/chart/gdchart0.11.5dev.tar.gz'
  sha1 'c23e1cd233c38ac007b57420c20a5fa7fa206841'
  version "0.11.5"

  depends_on :x11
  depends_on :libpng
  depends_on 'gd'

  def patches
    DATA
  end

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX_INC", include
      s.change_make_var! "PREFIX_LIB", lib
    end
    lib.mkpath
    include.mkpath
    system "make install"
  end

  def test
  end
end

__END__
--- gdchart0.11.5dev/Makefile   2004-12-17 12:53:47.000000000 -0500
+++ gdchart0.11.5dev-j/Makefile 2012-09-07 14:33:24.000000000 -0400
@@ -20,7 +20,7 @@
 # if it's not installed in a standard location edit these lines for your installation
 GD_INCL=/usr/local/include/
 GD_LD=/usr/local/lib/
-GD_LIB=libgd.so
+GD_LIB=libgd.dylib
 # a static libgd is also available
 # GD_LIB=libgd.a
 
@@ -29,6 +29,8 @@
 # if it's not installed in a standard location edit these lines for your installation
 # PNG_INCL = ../libpng-1.0.8
 # PNG_LD   = ../libpng-1.0.8
+PNG_INCL = /usr/X11/include
+PNG_LD   = /usr/X11/lib
 
 # ----- lib z -----
 # libgd requires zlib
@@ -51,7 +53,7 @@
 DEFS = $(FT_DEF) $(JPEG_DEF)
 LIBS = $(FT_LK) $(JPEG_LK)
 
-LIB_PATHS   = -L$(GD_LD) -L$(GDC_LD)
+LIB_PATHS   = -L$(GD_LD) -L$(GDC_LD) -L$(PNG_LD)
 # if not installed in standard paths (/lib, /usr/lib), or LD_LIBRARY_PATH
 # LIB_PATHS   = -L$(GD_LD) -L$(PNG_LD) -L$(ZLIB_LD) -L$(JPEG_LD)
 
