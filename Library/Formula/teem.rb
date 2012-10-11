require 'formula'

class Teem < Formula
  homepage 'http://teem.sourceforge.net/'
  url 'https://sourceforge.net/projects/teem/files/teem/1.10.0/teem-1.10.0-src.tar.gz'
  sha1 'f63ff41111ca5aa6ff6fc7653ec0e089da61bac6'

  head 'https://teem.svn.sourceforge.net/svnroot/teem/teem/trunk'

  depends_on 'cmake' => :build

  option 'experimental-apps', "Build experimental apps"
  option 'experimental-libs', "Build experimental libs"

  # fixes issues with linking to more recent libpng bundled with OS X
  # (fixed in head)
  def patches
    DATA
  end unless build.head?

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_SHARED_LIBS:BOOL=ON"

    if build.include? 'experimental-apps'
      cmake_args << "-DBUILD_EXPERIMENTAL_APPS:BOOL=ON"
    end
    if build.include? 'experimental-libs'
      cmake_args << "-DBUILD_EXPERIMENTAL_LIBS:BOOL=ON"
    end

    cmake_args << "."

    system "cmake", *cmake_args
    system "make install"
  end

  def test
    system "#{bin}/nrrdSanity"
  end
end

__END__
diff --git a/src/nrrd/formatPNG.c b/src/nrrd/formatPNG.c
index 75eaa10..564f3af 100644
--- a/src/nrrd/formatPNG.c
+++ b/src/nrrd/formatPNG.c
@@ -120,7 +120,7 @@ _nrrdErrorHandlerPNG (png_structp png, png_const_charp message)
   sprintf(err, "%s: PNG error: %s", me, message);
   biffAdd(NRRD, err);
   /* longjmp back to the setjmp, return 1 */
-  longjmp(png->jmpbuf, 1);
+  longjmp(png_jmpbuf(png), 1);
 }
 
 void
@@ -200,7 +200,7 @@ _nrrdFormatPNG_read(FILE *file, Nrrd *nrrd, NrrdIoState *nio) {
     biffAdd(NRRD, err); return 1;
   }
   /* set up png style error handling */
-  if (setjmp(png->jmpbuf)) {
+  if (setjmp(png_jmpbuf(png))) {
     /* the error is reported inside the handler, 
        but we still need to clean up and return */
     png_destroy_read_struct(&png, &info, NULL);
@@ -224,7 +224,7 @@ _nrrdFormatPNG_read(FILE *file, Nrrd *nrrd, NrrdIoState *nio) {
     png_set_palette_to_rgb(png);
   /* expand grayscale images to 8 bits from 1, 2, or 4 bits */
   if (type == PNG_COLOR_TYPE_GRAY && depth < 8)
-    png_set_gray_1_2_4_to_8(png);
+    png_set_expand_gray_1_2_4_to_8(png);
   /* expand paletted or rgb images with transparency to full alpha
      channels so the data will be available as rgba quartets */
   if (png_get_valid(png, info, PNG_INFO_tRNS))
@@ -420,7 +420,7 @@ _nrrdFormatPNG_write(FILE *file, const Nrrd *nrrd, NrrdIoState *nio) {
     biffAdd(NRRD, err); return 1;
   }
   /* set up error png style error handling */
-  if (setjmp(png->jmpbuf))
+  if (setjmp(png_jmpbuf(png)))
   {
     /* the error is reported inside the error handler, 
        but we still need to clean up an return with an error */
