require 'formula'

class LibofaHttpDownloadStrategy <CurlDownloadStrategy
  def stage
    safe_system '/usr/bin/tar', 'xf', @tarball_path
    chdir
    # need to convert newlines (dos2unix) or patch chokes
    safe_system "perl -pi -e 's/\\r\\n/\\n/g' lib/JAMA/tnt_math_utils.h"
  end
end

class Libofa <Formula
  url 'http://musicip-libofa.googlecode.com/files/libofa-0.9.3.tar.gz', :using => LibofaHttpDownloadStrategy
  homepage 'http://musicip-libofa.googlecode.com/'
  md5 '51507d2c4b432bd2755f48d58471696e'

  depends_on 'fftw'
  
  def patches
    DATA
  end

  def install
    system "autoreconf --force -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
__END__
diff --git a/configure.in b/configure.in
index 585b038..30f4c27 100644
--- a/configure.in
+++ b/configure.in
@@ -74,28 +74,19 @@ dnl Support libfftw2 and vSDP and MKL (intel)
 dnl  FFTW for FFTW v2. FFTW3 for FFTW v3. VDSP for vDSP. MKL for MKL
 dnl TODO: PREANSI for win32
 
-if test x$os = xdarwin; then
-    AC_MSG_NOTICE([Using vDSP on OS X])
-    LIBS="$LIBS -framework Accelerate"
-    FFT_WRAPPER="fftlibvdsp_op.cpp"
-    AM_CONDITIONAL(FFTW3, false)
-    AM_CONDITIONAL(VDSP, true)
-    AC_DEFINE_UNQUOTED(VDSP, 1, Use vDSP)
-else
-    AC_MSG_NOTICE([Using libfftw3])
-    AC_CHECK_LIB(fftw3, fftw_malloc,
-            [
-             LIBS="$LIBS -lfftw3"
-             FFT_WRAPPER="fftlibw3_op.cpp"
-             AM_CONDITIONAL(FFTW3, true)
-             AM_CONDITIONAL(VDSP, false)
-             AC_DEFINE_UNQUOTED(FFTW3, 1, Use libfftw3)
-            ], [
-            echo "*"
-            echo "*  libfft3 is needed to build this library."
-            echo "*"
-            AC_MSG_ERROR("Cannot build. Stop.")])
-fi
+AC_MSG_NOTICE([Using libfftw3])
+AC_CHECK_LIB(fftw3, fftw_malloc,
+		[
+		 LIBS="$LIBS -lfftw3"
+		 FFT_WRAPPER="fftlibw3_op.cpp"
+		 AM_CONDITIONAL(FFTW3, true)
+		 AM_CONDITIONAL(VDSP, false)
+		 AC_DEFINE_UNQUOTED(FFTW3, 1, Use libfftw3)
+		], [
+		echo "*"
+		echo "*  libfft3 is needed to build this library."
+		echo "*"
+		AC_MSG_ERROR("Cannot build. Stop.")])
 
 AC_SUBST(FFT_WRAPPER)
 
diff --git a/lib/JAMA/tnt_math_utils.h b/lib/JAMA/tnt_math_utils.h
index 26c16d5..fc944be 100644
--- a/lib/JAMA/tnt_math_utils.h
+++ b/lib/JAMA/tnt_math_utils.h
@@ -29,9 +29,10 @@ template <class Real>
 Real hypot(const Real &a, const Real &b)
 {
 	
-	if (a== 0)
+	if (a== 0) {
+		using __gnu_cxx::abs;
 		return abs(b);
-	else
+	} else
 	{
 		Real c = b/a;
 		return a * sqrt(1 + c*c);
