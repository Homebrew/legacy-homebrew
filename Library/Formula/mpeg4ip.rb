require 'formula'

class Mpeg4ip < Formula
  url 'http://downloads.sourceforge.net/project/mpeg4ip/mpeg4ip/1.5.0.1/mpeg4ip-1.5.0.1.tar.gz'
  homepage 'http://sourceforge.net/projects/mpeg4ip/'
  md5 'f53b06c62e914ab724bda9d9af041e08'

  depends_on 'sdl'
  depends_on 'faac'
  depends_on 'lame'
  depends_on 'xvid'
  depends_on 'x264'
  depends_on 'ffmpeg'

  # gcc 4.2.0+ / Reference: http://bugs.gentoo.org/show_bug.cgi?id=186637
  # Direct Gentoo patch download: http://bugs.gentoo.org/attachment.cgi?id=127145&action=diff&context=patch&collapsed=&headers=1&format=raw
  def patches; DATA; end

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-player"
    system "make install"
  end
end

__END__
diff --git a/common/video/iso-mpeg4/include/basic.hpp b/common/video/iso-mpeg4/include/basic.hpp
--- a/common/video/iso-mpeg4/include/basic.hpp	2005-05-04 19:55:58.000000000 +0000
+++ b/common/video/iso-mpeg4/include/basic.hpp	2006-12-13 10:15:12.283713250 +0000
@@ -89,12 +89,9 @@ 
 #define transpPixel CPixel(0,0,0,0)
 #define opaquePixel CPixel(255,255,255,255)
 
-#ifndef max
-#define max(a,b) (((a) > (b)) ? (a) : (b))
-#endif
-#ifndef min
-#define min(a, b)  (((a) < (b)) ? (a) : (b))
-#endif
+static inline long min( long x, long y ) { return ( ( x < y ) ? x : y ); }
+static inline long max( long x, long y ) { return ( ( x > y ) ? x : y ); }
+
 #define signOf(x) (((x) > 0) ? 1 : 0)
 #define invSignOf(x) ((x) > 0 ? 0 : 1)					// see p.22/H.263
 #define sign(x) ((x) > 0 ? 1 : -1)					// see p.22/H.263
diff --git a/common/video/iso-mpeg4/src/type_basic.cpp b/common/video/iso-mpeg4/src/type_basic.cpp
--- a/common/video/iso-mpeg4/src/type_basic.cpp	2005-05-04 19:55:58.000000000 +0000
+++ b/common/video/iso-mpeg4/src/type_basic.cpp	2006-12-13 10:15:12.283713250 +0000
@@ -317,13 +317,13 @@ 
 	iHalfY = m_vctTrueHalfPel.y - iMVY * 2;
 }

-Void CMotionVector::setToZero (Void)
+Void CMotionVector::setToZero ()
 {
 	memset (this, 0, sizeof (*this));
 }
 
 // RRV insertion
-Void CMotionVector::scaleup (Void)
+Void CMotionVector::scaleup ()
 {
 	if(m_vctTrueHalfPel.x == 0){
 		m_vctTrueHalfPel_x2.x = 0;

