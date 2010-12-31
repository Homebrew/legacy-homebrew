require 'formula'

class Octave <Formula
  url 'ftp://ftp.octave.org/pub/octave/octave-3.2.4.tar.gz'
  homepage 'http://www.gnu.org/software/octave'
  md5 '90c39fa9e241ad2e978bcee4682a2ba9'

  depends_on 'gnu-sed'
  #depends_on 'gawk'
  depends_on 'readline'
  #depends_on 'hdf5'
  #depends_on 'fftw'
  #depends_on 'curl'
  depends_on 'gfortran'

  def patches
    # A bug in lo-specfun.cc prevents it from compiling
    # apply patch from Macports
    DATA
  end

  def install
    ENV.deparallelize
    ENV["F77"] = "#{HOMEBREW_PREFIX}/bin/gfortran"
    ENV["FFLAGS"] = ENV["CFLAGS"]
    # configure asks for -ff2c to include blas
    ENV.append 'FFLAGS', "-ff2c"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--without-framework-carbon",
                          "--enable-readline",
                          "--without-zlib",
                          "--without-hdf5",
                          "--without-fftw",
                          "--without-glpk",
                          "--without-curl",
                          "--without-framework-opengl",
                          "--without-blas",
                          "--without-lapack",
                          "--without-qrupdate",
                          "--without-amd",
                          "--without-umfpack",
                          "--without-colamd",
                          "--without-ccolamd",
                          "--without-cholmod",
                          "--without-cxsparse",
                          "--without-arpack"

    system "make install"
  end
end

__END__
diff --git a/liboctave/lo-specfun.cc b/liboctave/lo-specfun.cc
index 6f16d2b..78d9236 100644
--- a/liboctave/lo-specfun.cc
+++ b/liboctave/lo-specfun.cc
@@ -25,6 +25,12 @@ along with Octave; see the file COPYING.  If not, see
 #include <config.h>
 #endif
 
+#if !defined (_REENTRANT)
+#define _REENTRANT
+#endif
+#include <cmath>
+#undef _REENTRANT
+
 #include "Range.h"
 #include "CColVector.h"
 #include "CMatrix.h"

