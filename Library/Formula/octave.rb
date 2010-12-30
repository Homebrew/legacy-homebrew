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
    # comment
    DATA
  end

  def install
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

    ENV.deparallelize
    ENV["F77"] = "#{HOMEBREW_PREFIX}/bin/gfortran"
    ENV["FFLAGS"] = ENV["CFLAGS"]
    # append -ff2c to FFLAGS if using blas
    # There is a bug in lo-specfun.cc which prevents from compiling, 
    # a patch is available from Macports
    system "make install"
  end
end

__END__

--- liboctave/lo-specfun.cc
+++ liboctave/lo-specfun.cc
@@ -25,6 +25,12 @@
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
