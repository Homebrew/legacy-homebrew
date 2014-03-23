require 'formula'

class Dcmtk < Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz'
  sha1 '469e017cffc56f36e834aa19c8612111f964f757'
  revision 1

  option 'with-docs', 'Install development libraries/headers and HTML docs'

  depends_on 'cmake' => :build
  depends_on "libpng"
  depends_on 'libtiff'
  depends_on 'doxygen' if build.with? "docs"

  # This roughly corresponds to thefollowing upstream patch:
  #
  #   http://git.dcmtk.org/web?p=dcmtk.git;a=commitdiff;h=dbadc0d8f3760f65504406c8b2cb8633f868a258
  #
  # However, this patch can't be applied as-is, since it refers to
  # some files that don't exist in the 3.6.0 release.
  #
  # This patch can be dropped once DCMTK makes a new release, but
  # since this is a very rare occurrence (the last development preview
  # release is from mid 2012), it seems justifiable to keep the patch
  # ourselves for a while.
  patch :DATA

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << '-DDCMTK_WITH_DOXYGEN=YES' if build.with? "docs"
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make DOXYGEN' if build.with? "docs"
      system 'make install'
    end
  end
end

__END__
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dimoflt.h b/dcmimgle/include/dcmtk/dcmimgle/dimoflt.h
index a88ab9d..da860fe 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dimoflt.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dimoflt.h
@@ -106,11 +106,11 @@ class DiMonoFlipTemplate
             if (this->Data != NULL)
             {
                 if (horz && vert)
-                    flipHorzVert(&pixel, &this->Data);
+                    this->flipHorzVert(&pixel, &this->Data);
                 else if (horz)
-                    flipHorz(&pixel, &this->Data);
+                    this->flipHorz(&pixel, &this->Data);
                 else if (vert)
-                    flipVert(&pixel, &this->Data);
+                    this->flipVert(&pixel, &this->Data);
             }
         }
     }
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dimoipxt.h b/dcmimgle/include/dcmtk/dcmimgle/dimoipxt.h
index e815e90..51603ea 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dimoipxt.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dimoipxt.h
@@ -76,10 +76,10 @@ class DiMonoInputPixelTemplate
             else if ((this->Modality != NULL) && this->Modality->hasRescaling())
             {
                 rescale(pixel, this->Modality->getRescaleSlope(), this->Modality->getRescaleIntercept());
-                determineMinMax(OFstatic_cast(T3, this->Modality->getMinValue()), OFstatic_cast(T3, this->Modality->getMaxValue()));
+                this->determineMinMax(OFstatic_cast(T3, this->Modality->getMinValue()), OFstatic_cast(T3, this->Modality->getMaxValue()));
             } else {
                 rescale(pixel);                     // "copy" or reference pixel data
-                determineMinMax(OFstatic_cast(T3, this->Modality->getMinValue()), OFstatic_cast(T3, this->Modality->getMaxValue()));
+                this->determineMinMax(OFstatic_cast(T3, this->Modality->getMinValue()), OFstatic_cast(T3, this->Modality->getMaxValue()));
             }
         }
     }
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dimopxt.h b/dcmimgle/include/dcmtk/dcmimgle/dimopxt.h
index 641acd2..dc0b439 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dimopxt.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dimopxt.h
@@ -178,7 +178,7 @@ class DiMonoPixelTemplate
         if ((idx >= 0) && (idx <= 1))
         {
             if ((idx == 1) && (MinValue[1] == 0) && (MaxValue[1] == 0))
-                determineMinMax(0, 0, 0x2);                                     // determine on demand
+                this->determineMinMax(0, 0, 0x2);                                     // determine on demand
             /* suppl. 33: "A Window Center of 2^n-1 and a Window Width of 2^n
                            selects the range of input values from 0 to 2^n-1."
             */
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dimorot.h b/dcmimgle/include/dcmtk/dcmimgle/dimorot.h
index 4ef277d..19f9a98 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dimorot.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dimorot.h
@@ -105,11 +105,11 @@ class DiMonoRotateTemplate
             if (this->Data != NULL)
             {
                 if (degree == 90)
-                    rotateRight(&pixel, &(this->Data));
+                    this->rotateRight(&pixel, &(this->Data));
                 else if (degree == 180)
-                    rotateTopDown(&pixel, &(this->Data));
+                    this->rotateTopDown(&pixel, &(this->Data));
                 else if (degree == 270)
-                    rotateLeft(&pixel, &(this->Data));
+                    this->rotateLeft(&pixel, &(this->Data));
             }
         }
     }
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dimosct.h b/dcmimgle/include/dcmtk/dcmimgle/dimosct.h
index 60c9abb..9a46187 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dimosct.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dimosct.h
@@ -124,7 +124,7 @@ class DiMonoScaleTemplate
             {
                 const T value = OFstatic_cast(T, OFstatic_cast(double, DicomImageClass::maxval(bits)) *
                     OFstatic_cast(double, pvalue) / OFstatic_cast(double, DicomImageClass::maxval(WIDTH_OF_PVALUES)));
-                scaleData(&pixel, &this->Data, interpolate, value);
+                this->scaleData(&pixel, &this->Data, interpolate, value);
              }
         }
     }
diff --git a/dcmimgle/include/dcmtk/dcmimgle/discalet.h b/dcmimgle/include/dcmtk/dcmimgle/discalet.h
index 758dde2..912e82a 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/discalet.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/discalet.h
@@ -206,12 +206,12 @@ class DiScaleTemplate
                 (Left >= OFstatic_cast(signed long, Columns)) || (Top >= OFstatic_cast(signed long, Rows)))
             {                                                                         // no image to be displayed
                 DCMIMGLE_DEBUG("clipping area is fully outside the image boundaries");
-                fillPixel(dest, value);                                               // ... fill bitmap
+                this->fillPixel(dest, value);                                         // ... fill bitmap
             }
             else if ((this->Src_X == this->Dest_X) && (this->Src_Y == this->Dest_Y))  // no scaling
             {
                 if ((Left == 0) && (Top == 0) && (Columns == this->Src_X) && (Rows == this->Src_Y))
-                    copyPixel(src, dest);                                             // copying
+                    this->copyPixel(src, dest);                                       // copying
                 else if ((Left >= 0) && (OFstatic_cast(Uint16, Left + this->Src_X) <= Columns) &&
                          (Top >= 0) && (OFstatic_cast(Uint16, Top + this->Src_Y) <= Rows))
                     clipPixel(src, dest);                                             // clipping
@@ -567,7 +567,7 @@ class DiScaleTemplate
         if ((xtemp == NULL) || (xvalue == NULL))
         {
             DCMIMGLE_ERROR("can't allocate temporary buffers for interpolation scaling");
-            clearPixel(dest);
+            this->clearPixel(dest);
         } else {
             for (int j = 0; j < this->Planes; ++j)
             {
@@ -905,7 +905,7 @@ class DiScaleTemplate
         if (pTemp == NULL)
         {
             DCMIMGLE_ERROR("can't allocate temporary buffer for interpolation scaling");
-            clearPixel(dest);
+            this->clearPixel(dest);
         } else {
 
             /*
@@ -1029,7 +1029,7 @@ class DiScaleTemplate
         if (pTemp == NULL)
         {
             DCMIMGLE_ERROR("can't allocate temporary buffer for interpolation scaling");
-            clearPixel(dest);
+            this->clearPixel(dest);
         } else {
 
             /*
diff --git a/dcmimgle/include/dcmtk/dcmimgle/diflipt.h b/dcmimgle/include/dcmtk/dcmimgle/diflipt.h
index 4933fe1..cb8d5e1 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/diflipt.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/diflipt.h
@@ -129,7 +129,7 @@ class DiFlipTemplate
             else if (vert)
                 flipVert(src, dest);
             else
-                copyPixel(src, dest);
+                this->copyPixel(src, dest);
         }
     }
 
diff --git a/dcmimgle/include/dcmtk/dcmimgle/dirotat.h b/dcmimgle/include/dcmtk/dcmimgle/dirotat.h
index edb452e..6ae6bbe 100644
--- a/dcmimgle/include/dcmtk/dcmimgle/dirotat.h
+++ b/dcmimgle/include/dcmtk/dcmimgle/dirotat.h
@@ -132,7 +132,7 @@ class DiRotateTemplate
         else if (degree == 270)
             rotateLeft(src, dest);
         else
-            copyPixel(src, dest);
+            this->copyPixel(src, dest);
     }
 
 
diff --git a/dcmimage/include/dcmtk/dcmimage/diargpxt.h b/dcmimage/include/dcmtk/dcmimage/diargpxt.h
index 7e3894d..a25c1f7 100644
--- a/dcmimage/include/dcmtk/dcmimage/diargpxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/diargpxt.h
@@ -91,7 +91,7 @@ class DiARGBPixelTemplate
                  const unsigned long planeSize,
                  const int bits)
     {                                             // not very much optimized, but no one really uses ARGB !!
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             register T2 value;
             const T1 offset = OFstatic_cast(T1, DicomImageClass::maxval(bits - 1));
diff --git a/dcmimage/include/dcmtk/dcmimage/dicmypxt.h b/dcmimage/include/dcmtk/dcmimage/dicmypxt.h
index 5357780..4050ec6 100644
--- a/dcmimage/include/dcmtk/dcmimage/dicmypxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dicmypxt.h
@@ -87,7 +87,7 @@ class DiCMYKPixelTemplate
                  const unsigned long planeSize,
                  const int bits)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             // use the number of input pixels derived from the length of the 'PixelData'
             // attribute), but not more than the size of the intermediate buffer
diff --git a/dcmimage/include/dcmtk/dcmimage/dicocpt.h b/dcmimage/include/dcmtk/dcmimage/dicocpt.h
index 0c06de7..9770770 100644
--- a/dcmimage/include/dcmtk/dcmimage/dicocpt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dicocpt.h
@@ -86,7 +86,7 @@ class DiColorCopyTemplate
     inline void copy(const T *pixel[3],
                      const unsigned long offset)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             for (int j = 0; j < 3; j++)
                 OFBitmanipTemplate<T>::copyMem(pixel[j] + offset, this->Data[j], this->getCount());
diff --git a/dcmimage/include/dcmtk/dcmimage/dicoflt.h b/dcmimage/include/dcmtk/dcmimage/dicoflt.h
index a5bed81..9c339f6 100644
--- a/dcmimage/include/dcmtk/dcmimage/dicoflt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dicoflt.h
@@ -98,14 +98,14 @@ class DiColorFlipTemplate
                      const int horz,
                      const int vert)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             if (horz && vert)
-                flipHorzVert(pixel, this->Data);
+                this->flipHorzVert(pixel, this->Data);
             else if (horz)
-                flipHorz(pixel, this->Data);
+                this->flipHorz(pixel, this->Data);
             else if (vert)
-                flipVert(pixel, this->Data);
+                this->flipVert(pixel, this->Data);
         }
     }
 };
diff --git a/dcmimage/include/dcmtk/dcmimage/dicorot.h b/dcmimage/include/dcmtk/dcmimage/dicorot.h
index 2bcd71e..9169f41 100644
--- a/dcmimage/include/dcmtk/dcmimage/dicorot.h
+++ b/dcmimage/include/dcmtk/dcmimage/dicorot.h
@@ -98,14 +98,14 @@ class DiColorRotateTemplate
     inline void rotate(const T *pixel[3],
                        const int degree)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             if (degree == 90)
-                rotateRight(pixel, this->Data);
+                this->rotateRight(pixel, this->Data);
             else if (degree == 180)
-                rotateTopDown(pixel, this->Data);
+                this->rotateTopDown(pixel, this->Data);
             else  if (degree == 270)
-                rotateLeft(pixel, this->Data);
+                this->rotateLeft(pixel, this->Data);
         }
     }
 };
diff --git a/dcmimage/include/dcmtk/dcmimage/dicosct.h b/dcmimage/include/dcmtk/dcmimage/dicosct.h
index 006a829..045b04f 100644
--- a/dcmimage/include/dcmtk/dcmimage/dicosct.h
+++ b/dcmimage/include/dcmtk/dcmimage/dicosct.h
@@ -107,8 +107,8 @@ class DiColorScaleTemplate
     inline void scale(const T *pixel[3],
                       const int interpolate)
     {
-        if (Init(pixel))
-            scaleData(pixel, this->Data, interpolate);
+        if (this->Init(pixel))
+            this->scaleData(pixel, this->Data, interpolate);
     }
 };
 
diff --git a/dcmimage/include/dcmtk/dcmimage/dihsvpxt.h b/dcmimage/include/dcmtk/dcmimage/dihsvpxt.h
index 10d8b70..d2c160b 100644
--- a/dcmimage/include/dcmtk/dcmimage/dihsvpxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dihsvpxt.h
@@ -87,7 +87,7 @@ class DiHSVPixelTemplate
                  const unsigned long planeSize,
                  const int bits)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             register T2 *r = this->Data[0];
             register T2 *g = this->Data[1];
diff --git a/dcmimage/include/dcmtk/dcmimage/dipalpxt.h b/dcmimage/include/dcmtk/dcmimage/dipalpxt.h
index 2e5eef7..875dac8 100644
--- a/dcmimage/include/dcmtk/dcmimage/dipalpxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dipalpxt.h
@@ -92,7 +92,7 @@ class DiPalettePixelTemplate
     void convert(const T1 *pixel,
                  DiLookupTable *palette[3])
     {                                                                // can be optimized if necessary !
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             register const T1 *p = pixel;
             register T2 value = 0;
diff --git a/dcmimage/include/dcmtk/dcmimage/dirgbpxt.h b/dcmimage/include/dcmtk/dcmimage/dirgbpxt.h
index 85f973d..ff18aaf 100644
--- a/dcmimage/include/dcmtk/dcmimage/dirgbpxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/dirgbpxt.h
@@ -87,7 +87,7 @@ class DiRGBPixelTemplate
                  const unsigned long planeSize,
                  const int bits)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             // use the number of input pixels derived from the length of the 'PixelData'
             // attribute), but not more than the size of the intermediate buffer
diff --git a/dcmimage/include/dcmtk/dcmimage/diybrpxt.h b/dcmimage/include/dcmtk/dcmimage/diybrpxt.h
index 6b523fb..1aff8d0 100644
--- a/dcmimage/include/dcmtk/dcmimage/diybrpxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/diybrpxt.h
@@ -91,7 +91,7 @@ class DiYBRPixelTemplate
                  const int bits,
                  const OFBool rgb)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             const T1 offset = OFstatic_cast(T1, DicomImageClass::maxval(bits - 1));
             // use the number of input pixels derived from the length of the 'PixelData'
diff --git a/dcmimage/include/dcmtk/dcmimage/diyf2pxt.h b/dcmimage/include/dcmtk/dcmimage/diyf2pxt.h
index ed27796..34343e5 100644
--- a/dcmimage/include/dcmtk/dcmimage/diyf2pxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/diyf2pxt.h
@@ -95,7 +95,7 @@ class DiYBR422PixelTemplate
                  const int bits,
                  const OFBool rgb)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             const T1 offset = OFstatic_cast(T1, DicomImageClass::maxval(bits - 1));
             register unsigned long i;
diff --git a/dcmimage/include/dcmtk/dcmimage/diyp2pxt.h b/dcmimage/include/dcmtk/dcmimage/diyp2pxt.h
index 518fed7..0c86165 100644
--- a/dcmimage/include/dcmtk/dcmimage/diyp2pxt.h
+++ b/dcmimage/include/dcmtk/dcmimage/diyp2pxt.h
@@ -91,7 +91,7 @@ class DiYBRPart422PixelTemplate
     void convert(const T1 *pixel,
                  const int bits)
     {
-        if (Init(pixel))
+        if (this->Init(pixel))
         {
             register T2 *r = this->Data[0];
             register T2 *g = this->Data[1];
diff --git a/ofstd/include/dcmtk/ofstd/ofoset.h b/ofstd/include/dcmtk/ofstd/ofoset.h
index 1a7f208..ee48743 100644
--- a/ofstd/include/dcmtk/ofstd/ofoset.h
+++ b/ofstd/include/dcmtk/ofstd/ofoset.h
@@ -146,7 +146,7 @@ template <class T> class OFOrderedSet : public OFSet<T>
       {
         // if size equals num, we need more space
         if( this->size == this->num )
-          Resize( this->size * 2 );
+          this->Resize( this->size * 2 );
 
         // copy item
         T *newItem = new T( item );
@@ -189,7 +189,7 @@ template <class T> class OFOrderedSet : public OFSet<T>
         {
           // if size equals num, we need more space
           if( this->size == this->num )
-            Resize( this->size * 2 );
+            this->Resize( this->size * 2 );
 
           // copy item
           T *newItem = new T( item );
