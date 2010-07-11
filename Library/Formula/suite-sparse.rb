require 'formula'

class SuiteSparse <Formula
  url 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-3.4.0.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/'
  md5 'e59dcabc9173b1ba1b3659ae147006b8'

  depends_on "metis"
  depends_on "tbb"

  def patches
    { :p1 => DATA }
  end

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.deparallelize

    # Statically link libmetis
    metis = Formula.factory("metis")
    ENV["HOMEBREW_METIS"] = "#{metis.lib}/libmetis.a"

    # So, SuiteSparse was written by a scientific researcher.  This
    # tends to result in makefile-based build systems that are completely
    # ignorant of the existance of things such as CPPFLAGS and LDFLAGS.
    # SuiteSparse Does The Right Thing™ when homebrew is in /usr/local
    # but if it is not, we have to piggyback some stuff in on CFLAGS.
    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      ENV['CFLAGS'] += " -isystem #{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    end

    system "make"

    lib.install Dir['*/Lib/*.a']
    include.install Dir['*/Include/*.h']
    include.install 'UFconfig/UFconfig.h'
  end
end

__END__
Patch to the SuiteSparse master Make configuration file.
Ensures SuiteSparse builds against Hombrew's copy of metis
and uses Hombrew environment variables related to compilation.
diff --git a/UFconfig/UFconfig.mk b/UFconfig/UFconfig.mk
index bda4c7b..84a878b 100644
--- a/UFconfig/UFconfig.mk
+++ b/UFconfig/UFconfig.mk
@@ -33,11 +33,11 @@
 # C compiler and compiler flags:  These will normally not give you optimal
 # performance.  You should select the optimization parameters that are best
 # for your system.  On Linux, use "CFLAGS = -O3 -fexceptions" for example.
-CC = cc
+# CC = cc
 # CFLAGS = -O   (for example; see below for details)
 
 # C++ compiler (also uses CFLAGS)
-CPLUSPLUS = g++
+CPLUSPLUS = $(CXX)
 
 # ranlib, and ar, for generating libraries
 RANLIB = ranlib
@@ -49,11 +49,11 @@ MV = mv -f
 
 # Fortran compiler (not normally required)
 F77 = f77
-F77FLAGS = -O
+F77FLAGS = $(FCFLAGS)
 F77LIB =
 
 # C and Fortran libraries
-LIB = -lm
+LIB = -lm -lstdc++ $(LDFLAGS)
 
 # For compiling MATLAB mexFunctions (MATLAB 7.5 or later)
 MEX = mex -O -largeArrayDims -lmwlapack -lmwblas
@@ -89,8 +89,8 @@ MEX = mex -O -largeArrayDims -lmwlapack -lmwblas
 # BLAS = -lgoto -lgfortran -lgfortranbegin -lg2c
 
 # This is probably slow ... it might connect to the Standard Reference BLAS:
-BLAS = -lblas -lgfortran -lgfortranbegin -lg2c
-LAPACK = -llapack
+BLAS = -Wl,-framework -Wl,Accelerate
+LAPACK = $(BLAS)
 
 # Using non-optimized versions:
 # BLAS = -lblas_plain -lgfortran -lgfortranbegin -lg2c
@@ -122,8 +122,8 @@ XERBLA =
 # The path is relative to where it is used, in CHOLMOD/Lib, CHOLMOD/MATLAB, etc.
 # You may wish to use an absolute path.  METIS is optional.  Compile
 # CHOLMOD with -DNPARTITION if you do not wish to use METIS.
-METIS_PATH = ../../metis-4.0
-METIS = ../../metis-4.0/libmetis.a
+METIS_PATH =
+METIS = $(HOMEBREW_METIS)
 
 # If you use CHOLMOD_CONFIG = -DNPARTITION then you must use the following
 # options:
@@ -198,16 +198,16 @@ CHOLMOD_CONFIG =
 # -DHAVE_TBB        enable the use of Intel's Threading Building Blocks (TBB)
 
 # default, without timing, without TBB:
-SPQR_CONFIG =
+SPQR_CONFIG = -DHAVE_TBB
 # with timing and TBB:
 # SPQR_CONFIG = -DTIMING -DHAVE_TBB
 # with timing
 # SPQR_CONFIG = -DTIMING
 
 # with TBB, you must select this:
-# TBB = -ltbb
+TBB = -ltbb
 # without TBB:
-TBB =
+# TBB =
 
 # with timing, you must include the timing library:
 # RTLIB = -lrt
@@ -220,7 +220,7 @@ RTLIB =
 
 # Using default compilers:
 # CC = gcc
-CFLAGS = -O3 -fexceptions
+# CFLAGS = -O3 -fexceptions
 
 # alternatives:
 # CFLAGS = -g -fexceptions \
