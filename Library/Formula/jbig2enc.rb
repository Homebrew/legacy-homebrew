require 'formula'

class Jbig2enc < Formula
  homepage 'https://github.com/agl/jbig2enc'
  url 'https://github.com/agl/jbig2enc.git',
      :tag => '17b36fad1e64a378f11eb934e8ca25f4b0008a4f'
  version '0.27-17b36fa'

  depends_on 'leptonica'
  depends_on 'libtiff'
  depends_on 'jpeg'

  def patches
    # jbig2enc hardcodes the include and libraries paths.
    # Fixing them up for Homebrew
    # Also contains a patch to pdf.py that retains DPI:
    # https://github.com/agl/jbig2enc/issues/15
    DATA
  end

  def install
    system "make"
    bin.install 'jbig2', 'pdf.py'
    lib.install 'libjbig2enc.a'
  end
end

__END__
diff --git a/Makefile b/Makefile
index dbb4556..aac8101 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,11 @@
 CC=g++
-LEPTONICA=../leptonica-1.68
+LEPTONICA=`brew --prefix`/include/leptonica
 # For example, a fink MacOSX install:
 # EXTRA=-I/sw/include/ -I/sw/include/libpng -I/sw/include/libjpeg -L/sw/lib
-CFLAGS=-I${LEPTONICA}/src -Wall -I/usr/include -L/usr/lib -O3 ${EXTRA}
+CFLAGS=-I${LEPTONICA} -Wall -I`brew --prefix`/include -L`brew --prefix`/lib -L/usr/X11/lib -O3 ${EXTRA}
 
 jbig2: libjbig2enc.a jbig2.cc
-	$(CC) -o jbig2 jbig2.cc -L. -ljbig2enc ${LEPTONICA}/src/.libs/liblept.a $(CFLAGS) -lpng -ljpeg -ltiff -lm -lz
+	$(CC) -o jbig2 jbig2.cc -L. -ljbig2enc `brew --prefix`/lib/liblept.a $(CFLAGS) -lpng -ljpeg -ltiff -lm -lz
 
 libjbig2enc.a: jbig2enc.o jbig2arith.o jbig2sym.o
 	ar -rcv libjbig2enc.a jbig2enc.o jbig2arith.o jbig2sym.o
diff --git a/pdf.py b/pdf.py
index cd37c9f..4b4a8e8 100644
--- a/pdf.py
+++ b/pdf.py
@@ -11,7 +11,7 @@ import os
 # Run ./jbig2 -s -p <other options> image1.jpeg image1.jpeg ...
 # python pdf.py output > out.pdf

-dpi = 600
+#dpi = 600

 class Ref:
   def __init__(self, x):
@@ -121,16 +121,16 @@ def main(symboltable='symboltable', pagefiles=glob.glob('page-*')):
     except IOError:
       sys.stderr.write("error reading page file %s\n"% p)
       continue
-    (width, height) = struct.unpack('>II', contents[11:19])
+    (width, height,xres,yres) = struct.unpack('>IIII', contents[11:27])
     xobj = Obj({'Type': '/XObject', 'Subtype': '/Image', 'Width':
         str(width), 'Height': str(height), 'ColorSpace': '/DeviceGray',
         'BitsPerComponent': '1', 'Filter': '/JBIG2Decode', 'DecodeParms':
         ' << /JBIG2Globals %d 0 R >>' % symd.id}, contents)
-    contents = Obj({}, 'q %f 0 0 %f 0 0 cm /Im1 Do Q' % (float(width * 72) / dpi, float(height * 72) / dpi))
+    contents = Obj({}, 'q %f 0 0 %f 0 0 cm /Im1 Do Q' % (float(width * 72) / xres, float(height * 72) / yres))
     resources = Obj({'ProcSet': '[/PDF /ImageB]',
         'XObject': '<< /Im1 %d 0 R >>' % xobj.id})
     page = Obj({'Type': '/Page', 'Parent': '3 0 R',
-        'MediaBox': '[ 0 0 %f %f ]' % (float(width * 72) / dpi, float(height * 72) / dpi),
+        'MediaBox': '[ 0 0 %f %f ]' % (float(width * 72) / xres, float(height * 72) / yres),
         'Contents': ref(contents.id),
         'Resources': ref(resources.id)})
     [doc.add_object(x) for x in [xobj, contents, resources, page]]
