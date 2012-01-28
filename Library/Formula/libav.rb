require 'formula'

class Libav < Formula
  url 'http://libav.org/releases/libav-0.7_beta2.tar.gz'
  homepage 'http://libav.org/'
  md5 '1cd2ba650c3ee16f603360d005a77ffa'
  head 'git://git.libav.org/libav.git', :using => :git

  depends_on 'yasm'
  depends_on 'dirac'
  depends_on 'faac'
  depends_on 'libgsm'
  depends_on 'libvorbis'
  depends_on 'libvpx'
  depends_on 'opencore-amr'
  depends_on 'openjpeg'
  depends_on 'rtmpdump'
  depends_on 'speex'
  depends_on 'theora'
  depends_on 'xvid'
  depends_on 'x264'

    # Apply patched based on http://hexeract.wordpress.com/2009/04/12/how-to-compile-ffmpegmplayer-for-macosx/
#  def patches
#    DATA
#  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--as=yasm", "--enable-gpl",
                          "--enable-version3", "--enable-nonfree",
                          "--enable-gray", "--enable-vdpau", "--enable-bzlib",
                          "--disable-runtime-cpudetect", "--enable-zlib",
                          "--enable-frei0r", "--enable-libdirac",
                          "--enable-libfaac", "--enable-libgsm",
                          "--enable-libtheora", "--enable-libmp3lame",
                          "--enable-libopencore-amrnb",
                          "--enable-libopencore-amrwb",
                          "--enable-libopenjpeg", "--enable-librtmp",
                          "--enable-libschroedinger", "--enable-libspeex",
                          "--enable-libvo-amrwbenc", "--enable-libvo-aacenc",
                          "--enable-libvorbis", "--enable-libvpx",
                          "--enable-libx264", "--enable-libxvid"
    system "make install"
  end
end

__END__
diff -git a/libswscale/x86/yuv2rgb_mmx.c b/libswscale/x86/yuv2rgb_mmx.c
--- a/libswscale/x86/yuv2rgb_mmx.c	2011-05-12 16:15:19.000000000 +0200
+++ b/libswscale/x86/yuv2rgb_mmx.c	2011-06-12 16:08:36.000000000 +0200
@@ -47,17 +47,17 @@
 
 //MMX versions
 #undef RENAME
-#undef HAVE_MMX2
+#undef HAVE_MMX
 #undef HAVE_AMD3DNOW
-#define HAVE_MMX2 0
+#define HAVE_MMX 0
 #define HAVE_AMD3DNOW 0
 #define RENAME(a) a ## _MMX
 #include "yuv2rgb_template.c"
 
 //MMX2 versions
 #undef RENAME
-#undef HAVE_MMX2
-#define HAVE_MMX2 1
+#undef HAVE_MMX
+#define HAVE_MMX 1
 #define RENAME(a) a ## _MMX2
 #include "yuv2rgb_template.c"
 
@@ -75,8 +75,8 @@
                 if (HAVE_7REGS) return yuva420_bgr32_MMX2;
                 break;
             } else return yuv420_bgr32_MMX2;
-        case PIX_FMT_RGB24:  return yuv420_rgb24_MMX2;
-        case PIX_FMT_BGR24:  return yuv420_bgr24_MMX2;
+        case PIX_FMT_RGB24:  return yuv420_rgb24_MMX;
+        case PIX_FMT_BGR24:  return yuv420_bgr24_MMX;
         case PIX_FMT_RGB565: return yuv420_rgb16_MMX2;
         case PIX_FMT_RGB555: return yuv420_rgb15_MMX2;
         }

