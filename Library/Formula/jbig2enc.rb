require 'formula'

class Jbig2enc < Formula
  url 'https://github.com/agl/jbig2enc.git', :using => :git, :tag => '17b36fad1e64a378f11eb934e8ca25f4b0008a4f'
  homepage 'https://github.com/agl/jbig2enc'
  version '0.27-17b36fa'

  depends_on 'leptonica'
  depends_on 'libtiff'
  depends_on 'jpeg'

  def patches
    # jbig2enc hardcodes the include and libraries paths.
    # Fixing them up for Homebrew
    DATA
  end

  def install
    system "make"
    bin.install ['jbig2', 'pdf.py']
    lib.install ['libjbig2enc.a']
  end
end

__END__
diff --git a/Makefile b/Makefile
index 0553375..e728c40 100644
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
