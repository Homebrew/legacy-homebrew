require 'formula'

class Jbig2enc < Formula
	head 'https://github.com/agl/jbig2enc.git'
  homepage 'https://github.com/agl/jbig2enc'

  depends_on 'libtiff'
  depends_on 'jpeg'

	def patches
		# jbig2enc hardcodes the include and libraries paths.
		# fixing them up for Homebrew
		DATA
	end

  def install
    system "curl", "-O", "http://leptonica.org/source/leptonlib-1.67.tar.gz"
    system "tar", "-xzf", "leptonlib-1.67.tar.gz"
		Dir.chdir("./leptonlib-1.67/")
    system "./configure", "--enable-shared=no", "--enable-static=yes", "--disable-debug", "--disable-depdendency-tracking"
    system "make"
		Dir.chdir("../")
    system "make"
		bin.install ['jbig2', 'pdf.py']
		lib.install ['libjbig2enc.a']
  end
end

__END__
diff --git a/Makefile b/Makefile
index 0553375..3a25f8b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 CC=g++
-LEPTONICA=../leptonlib-1.67
+LEPTONICA=./leptonlib-1.67
 # For example, a fink MacOSX install:
 # EXTRA=-I/sw/include/ -I/sw/include/libpng -I/sw/include/libjpeg -L/sw/lib
-CFLAGS=-I${LEPTONICA}/src -Wall -I/usr/include -L/usr/lib -O3 ${EXTRA}
+CFLAGS=-I${LEPTONICA}/src -Wall -I`brew --prefix`/include -L`brew --prefix`/lib -L/usr/X11/lib -O3 ${EXTRA}
 
 jbig2: libjbig2enc.a jbig2.cc
 	$(CC) -o jbig2 jbig2.cc -L. -ljbig2enc ${LEPTONICA}/src/.libs/liblept.a $(CFLAGS) -lpng -ljpeg -ltiff -lm -lz
