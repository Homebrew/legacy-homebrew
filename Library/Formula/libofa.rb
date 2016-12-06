require 'formula'

class Libofa <Formula
  url 'http://musicip-libofa.googlecode.com/files/libofa-0.9.3.tar.gz'
  homepage 'http://code.google.com/p/musicip-libofa/'
  md5 '51507d2c4b432bd2755f48d58471696e'

  def patches
    { :p0 => DATA }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

__END__
--- examples/example.cpp.orig	2006-05-10 21:05:37.000000000 +0300
+++ examples/example.cpp	2008-04-16 15:51:49.000000000 +0300
@@ -9,6 +9,8 @@
 
 #include "protocol.h"
 
+#include <string.h>
+ 
 AudioData* loadWaveFile(char *file);
 AudioData* loadDataUsingLAME(char *file);
 
Vain hakemistossa libofa-0.9.3/examples: example.cpp.orig
--- examples/protocol.cpp.orig	2006-05-10 21:05:42.000000000 +0300
+++ examples/protocol.cpp	2008-04-16 15:51:49.000000000 +0300
@@ -8,6 +8,7 @@
 -------------------------------------------------------------------*/
 #include <stdio.h>
 #include <stdlib.h>
+#include <cstring>
 #include <string>
 #include <map>
 #include <expat.h>
--- lib/signal_op.cpp.orig	2006-05-10 21:01:12.000000000 +0300
+++ lib/signal_op.cpp	2008-04-16 15:51:49.000000000 +0300
@@ -12,6 +12,7 @@
 // DATE CREATED: 1/12/06
 
 
+#include <cstdlib>
 #include <math.h>
 #include "signal_op.h"
 #include "AFLIB/aflibConverter.h"
--- lib/JAMA/tnt_math_utils.h.orig	2006-06-17 01:46:22.000000000 +0300
+++ lib/JAMA/tnt_math_utils.h	2006-06-17 01:47:02.000000000 +0300
@@ -20,11 +20,20 @@
 namespace TNT
 {
 /**
+	@returns the absolute value of a real (no-complex) scalar.
+*/
+template <class Real>
+Real abs(const Real &a)
+{
+	return  (a > 0 ? a : -a);
+}
+/**
 	@returns hypotenuse of real (non-complex) scalars a and b by 
 	avoiding underflow/overflow
 	using (a * sqrt( 1 + (b/a) * (b/a))), rather than
 	sqrt(a*a + b*b).
 */
+
 template <class Real>
 Real hypot(const Real &a, const Real &b)
 {
@@ -56,15 +65,6 @@
 }
 */
 
-/**
-	@returns the absolute value of a real (no-complex) scalar.
-*/
-template <class Real>
-Real abs(const Real &a)
-{
-	return  (a > 0 ? a : -a);
-}
-
 }
 #endif
 /* MATH_UTILS_H */
--- lib/fftlibvdsp_op.cpp.orig	2006-05-10 11:00:57.000000000 -0700
+++ lib/fftlibvdsp_op.cpp	2010-12-19 10:42:58.000000000 -0800
@@ -23,12 +23,12 @@
 	{
 		delete[] A.realp;
 		delete[] A.imagp;
-		destroy_fftsetupD(SetupReal);
+		vDSP_destroy_fftsetupD(SetupReal);
 	}
 		
 	A.realp = new double[ N/2];
 	A.imagp = new double[ N/2];
-	SetupReal = create_fftsetupD(Exp, 0);
+	SetupReal = vDSP_create_fftsetupD(Exp, 0);
 	Init = true;
 }
 
@@ -46,9 +46,9 @@
 void 
 FFTLib_op::ComputeFrame(int N, double *in, double *out)
 {
-	ctozD ((DSPDoubleComplex*) in, 2, &A, 1, N/2 );
+	vDSP_ctozD ((DSPDoubleComplex*) in, 2, &A, 1, N/2 );
 	
-	fft_zripD(SetupReal, &A, 1, Exp, FFT_FORWARD);
+	vDSP_fft_zripD(SetupReal, &A, 1, Exp, FFT_FORWARD);
 	
 	int i,j;
 	for (i=0; i<N/2; i++)
--- configure.orig	2010-12-19 10:46:09.000000000 -0800
+++ configure	2010-12-19 10:46:19.000000000 -0800
@@ -20486,7 +20486,7 @@
 if test x$os = xdarwin; then
     { echo "$as_me:$LINENO: Using vDSP on OS X" >&5
 echo "$as_me: Using vDSP on OS X" >&6;}
-    LIBS="$LIBS -framework Accelerate"
+    LIBS="$LIBS -XCClinker -framework -XCClinker Accelerate"
     FFT_WRAPPER="fftlibvdsp_op.cpp"
 
 
