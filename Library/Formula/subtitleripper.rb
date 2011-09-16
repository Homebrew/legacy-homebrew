require 'formula'

class Subtitleripper < Formula
  url 'http://downloads.sourceforge.net/subtitleripper/subtitleripper-0.3.tgz'
  homepage ''
  md5 'a727abdf31564eb3f98af6aba3dcc234'

  depends_on 'transcode'

  def patches
    { :p0 => DATA }
  end

  def install
    system "make"
    
    bin.install "srttool"
    bin.install "subtitle2pgm"
    bin.install "subtitle2vobsub"
  end
end

__END__

Don't expect PPM (whatever that is!)

--- Makefile.orig	2011-08-10 14:12:48.000000000 +0100
+++ Makefile	2011-08-10 14:13:02.000000000 +0100
@@ -8,8 +8,8 @@
 INCLUDES :=
 
 ### enable ppm support ###
-DEFINES  += -D_HAVE_LIB_PPM_
-LIBS     += -lppm
+# DEFINES  += -D_HAVE_LIB_PPM_
+# LIBS     += -lppm
 
 ### enable zlib support ###
 DEFINES += -D_HAVE_ZLIB_
