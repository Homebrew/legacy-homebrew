require 'formula'

class Libquicktime <Formula
  url 'http://downloads.sourceforge.net/project/libquicktime/libquicktime/1.1.5/libquicktime-1.1.5.tar.gz'
  homepage 'http://libquicktime.sourceforge.net/'
  md5 '0fd45b3deff0317c2f85a34b1b106acf'

  def patches
      # http://bugs.gentoo.org/show_bug.cgi?id=294488
      #
      # Previous version jpeg automatically set dinfo.do_fancy_downsampling to FALSE.
      # Newer versions (since 7) of media-libs/jpeg do not do that anymore and the
      # program must do it explicitly
      DATA
  end

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'jpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen"
    system "make"
    system "make install"
  end
end

__END__
--- libquicktime-1.1.5/plugins/mjpeg/libmjpeg.c	2010-01-15 05:41:17.000000000 +1100
+++ libquicktime-1.1.5/plugins/mjpeg/libmjpeg.c-2	2010-04-07 23:33:46.000000000 +1000
@@ -785,6 +785,7 @@
   result->jpeg_compress.input_components = 3;
   result->jpeg_compress.in_color_space = JCS_RGB;
   jpeg_set_quality(&(result->jpeg_compress), mjpeg->quality, 0);
+  result->jpeg_compress.do_fancy_downsampling = FALSE;
 
   if(mjpeg->use_float) 
     result->jpeg_compress.dct_method = JDCT_FLOAT;
