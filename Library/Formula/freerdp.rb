require 'formula'

class Freerdp < Formula
  homepage 'http://www.freerdp.com/'
  url 'https://github.com/FreeRDP/FreeRDP/tarball/1.0.0'
  md5 '53b0a12c367b9b3a8dbe60e7fa0f88e9'
  head 'https://github.com/FreeRDP/FreeRDP.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  # Fixes clang build problems
  # Already upstream, check for removal on next release:
  # https://github.com/FreeRDP/FreeRDP/pull/544
  def patches
    DATA
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

__END__
diff --git a/libfreerdp-core/orders.c b/libfreerdp-core/orders.c
index c555fab..7de0371 100644
--- a/libfreerdp-core/orders.c
+++ b/libfreerdp-core/orders.c
@@ -232,7 +232,7 @@ INLINE void update_read_2byte_signed(STREAM* s, sint32* value)
 		*value *= -1;
 }
 
-INLINE void update_read_4byte_unsigned(STREAM* s, uint32* value)
+static INLINE void update_read_4byte_unsigned(STREAM* s, uint32* value)
 {
 	uint8 byte;
 	uint8 count;
@@ -316,7 +316,7 @@ INLINE void update_seek_glyph_delta(STREAM* s)
 		stream_seek_uint8(s);
 }
 
-INLINE void update_read_brush(STREAM* s, rdpBrush* brush, uint8 fieldFlags)
+static INLINE void update_read_brush(STREAM* s, rdpBrush* brush, uint8 fieldFlags)
 {
 	if (fieldFlags & ORDER_FIELD_01)
 		stream_read_uint8(s, brush->x);
@@ -354,7 +354,7 @@ INLINE void update_read_brush(STREAM* s, rdpBrush* brush, uint8 fieldFlags)
 	}
 }
 
-INLINE void update_read_delta_rects(STREAM* s, DELTA_RECT* rectangles, int number)
+static INLINE void update_read_delta_rects(STREAM* s, DELTA_RECT* rectangles, int number)
 {
 	int i;
 	uint8 flags = 0;
@@ -399,7 +399,7 @@ INLINE void update_read_delta_rects(STREAM* s, DELTA_RECT* rectangles, int numbe
 	}
 }
 
-INLINE void update_read_delta_points(STREAM* s, DELTA_POINT* points, int number, sint16 x, sint16 y)
+static INLINE void update_read_delta_points(STREAM* s, DELTA_POINT* points, int number, sint16 x, sint16 y)
 {
 	int i;
 	uint8 flags = 0;
diff --git a/libfreerdp-gdi/16bpp.c b/libfreerdp-gdi/16bpp.c
index 2c5102a..87418c4 100644
--- a/libfreerdp-gdi/16bpp.c
+++ b/libfreerdp-gdi/16bpp.c
@@ -791,96 +791,96 @@ int PatBlt_16bpp(HGDI_DC hdc, int nXLeft, int nYLeft, int nWidth, int nHeight, i
 	return 1;
 }
 
-INLINE void SetPixel_BLACK_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_BLACK_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = 0 */
 	*pixel = 0;
 }
 
-INLINE void SetPixel_NOTMERGEPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOTMERGEPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = ~(D | P) */
 	*pixel = ~(*pixel | *pen);
 }
 
-INLINE void SetPixel_MASKNOTPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MASKNOTPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = D & ~P */
 	*pixel &= ~(*pen);
 }
 
-INLINE void SetPixel_NOTCOPYPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOTCOPYPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = ~P */
 	*pixel = ~(*pen);
 }
 
-INLINE void SetPixel_MASKPENNOT_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MASKPENNOT_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = P & ~D */
 	*pixel = *pen & ~*pixel;
 }
 
-INLINE void SetPixel_NOT_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOT_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = ~D */
 	*pixel = ~(*pixel);
 }
 
-INLINE void SetPixel_XORPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_XORPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = D ^ P */
 	*pixel = *pixel ^ *pen;
 }
 
-INLINE void SetPixel_NOTMASKPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOTMASKPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = ~(D & P) */
 	*pixel = ~(*pixel & *pen);
 }
 
-INLINE void SetPixel_MASKPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MASKPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = D & P */
 	*pixel &= *pen;
 }
 
-INLINE void SetPixel_NOTXORPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOTXORPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = ~(D ^ P) */
 	*pixel = ~(*pixel ^ *pen);
 }
 
-INLINE void SetPixel_NOP_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_NOP_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = D */
 }
 
-INLINE void SetPixel_MERGENOTPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MERGENOTPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = D | ~P */
 	*pixel |= ~(*pen);
 }
 
-INLINE void SetPixel_COPYPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_COPYPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = P */
 	*pixel = *pen;
 }
 
-INLINE void SetPixel_MERGEPENNOT_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MERGEPENNOT_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = P | ~D */
 	*pixel = *pen | ~(*pixel);
 }
 
-INLINE void SetPixel_MERGEPEN_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_MERGEPEN_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = P | D */
 	*pixel |= *pen;
 }
 
-INLINE void SetPixel_WHITE_16bpp(uint16 *pixel, uint16 *pen)
+static INLINE void SetPixel_WHITE_16bpp(uint16 *pixel, uint16 *pen)
 {
 	/* D = 1 */
 	*pixel = 0xFFFF;
diff --git a/libfreerdp-gdi/32bpp.c b/libfreerdp-gdi/32bpp.c
index 3c72856..fe71627 100644
--- a/libfreerdp-gdi/32bpp.c
+++ b/libfreerdp-gdi/32bpp.c
@@ -820,96 +820,96 @@ int PatBlt_32bpp(HGDI_DC hdc, int nXLeft, int nYLeft, int nWidth, int nHeight, i
 	return 1;
 }
 
-INLINE void SetPixel_BLACK_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_BLACK_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = 0 */
 	*pixel = 0;
 }
 
-INLINE void SetPixel_NOTMERGEPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOTMERGEPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = ~(D | P) */
 	*pixel = ~(*pixel | *pen);
 }
 
-INLINE void SetPixel_MASKNOTPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MASKNOTPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = D & ~P */
 	*pixel &= ~(*pen);
 }
 
-INLINE void SetPixel_NOTCOPYPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOTCOPYPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = ~P */
 	*pixel = ~(*pen);
 }
 
-INLINE void SetPixel_MASKPENNOT_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MASKPENNOT_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = P & ~D */
 	*pixel = *pen & ~*pixel;
 }
 
-INLINE void SetPixel_NOT_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOT_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = ~D */
 	*pixel = ~(*pixel);
 }
 
-INLINE void SetPixel_XORPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_XORPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = D ^ P */
 	*pixel = *pixel ^ *pen;
 }
 
-INLINE void SetPixel_NOTMASKPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOTMASKPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = ~(D & P) */
 	*pixel = ~(*pixel & *pen);
 }
 
-INLINE void SetPixel_MASKPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MASKPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = D & P */
 	*pixel &= *pen;
 }
 
-INLINE void SetPixel_NOTXORPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOTXORPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = ~(D ^ P) */
 	*pixel = ~(*pixel ^ *pen);
 }
 
-INLINE void SetPixel_NOP_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_NOP_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = D */
 }
 
-INLINE void SetPixel_MERGENOTPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MERGENOTPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = D | ~P */
 	*pixel |= ~(*pen);
 }
 
-INLINE void SetPixel_COPYPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_COPYPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = P */
 	*pixel = *pen;
 }
 
-INLINE void SetPixel_MERGEPENNOT_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MERGEPENNOT_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = P | ~D */
 	*pixel = *pen | ~(*pixel);
 }
 
-INLINE void SetPixel_MERGEPEN_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_MERGEPEN_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = P | D */
 	*pixel |= *pen;
 }
 
-INLINE void SetPixel_WHITE_32bpp(uint32 *pixel, uint32 *pen)
+static INLINE void SetPixel_WHITE_32bpp(uint32 *pixel, uint32 *pen)
 {
 	/* D = 1 */
 	*pixel = 0xFFFFFF;
diff --git a/libfreerdp-gdi/8bpp.c b/libfreerdp-gdi/8bpp.c
index c4f2615..7422e83 100644
--- a/libfreerdp-gdi/8bpp.c
+++ b/libfreerdp-gdi/8bpp.c
@@ -700,96 +700,96 @@ int PatBlt_8bpp(HGDI_DC hdc, int nXLeft, int nYLeft, int nWidth, int nHeight, in
 	return 1;
 }
 
-INLINE void SetPixel_BLACK_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_BLACK_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = 0 */
 	*pixel = 0;
 }
 
-INLINE void SetPixel_NOTMERGEPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOTMERGEPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = ~(D | P) */
 	*pixel = ~(*pixel | *pen);
 }
 
-INLINE void SetPixel_MASKNOTPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MASKNOTPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = D & ~P */
 	*pixel &= ~(*pen);
 }
 
-INLINE void SetPixel_NOTCOPYPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOTCOPYPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = ~P */
 	*pixel = ~(*pen);
 }
 
-INLINE void SetPixel_MASKPENNOT_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MASKPENNOT_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = P & ~D */
 	*pixel = *pen & ~*pixel;
 }
 
-INLINE void SetPixel_NOT_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOT_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = ~D */
 	*pixel = ~(*pixel);
 }
 
-INLINE void SetPixel_XORPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_XORPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = D ^ P */
 	*pixel = *pixel ^ *pen;
 }
 
-INLINE void SetPixel_NOTMASKPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOTMASKPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = ~(D & P) */
 	*pixel = ~(*pixel & *pen);
 }
 
-INLINE void SetPixel_MASKPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MASKPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = D & P */
 	*pixel &= *pen;
 }
 
-INLINE void SetPixel_NOTXORPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOTXORPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = ~(D ^ P) */
 	*pixel = ~(*pixel ^ *pen);
 }
 
-INLINE void SetPixel_NOP_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_NOP_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = D */
 }
 
-INLINE void SetPixel_MERGENOTPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MERGENOTPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = D | ~P */
 	*pixel |= ~(*pen);
 }
 
-INLINE void SetPixel_COPYPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_COPYPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = P */
 	*pixel = *pen;
 }
 
-INLINE void SetPixel_MERGEPENNOT_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MERGEPENNOT_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = P | ~D */
 	*pixel = *pen | ~(*pixel);
 }
 
-INLINE void SetPixel_MERGEPEN_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_MERGEPEN_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = P | D */
 	*pixel |= *pen;
 }
 
-INLINE void SetPixel_WHITE_8bpp(uint8* pixel, uint8* pen)
+static INLINE void SetPixel_WHITE_8bpp(uint8* pixel, uint8* pen)
 {
 	/* D = 1 */
 	*pixel = 0xFF;
