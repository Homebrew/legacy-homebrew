require 'formula'

class Dsdp < Formula
  homepage 'http://www.mcs.anl.gov/hs/software/DSDP/'
  url 'http://www.mcs.anl.gov/hs/software/DSDP/DSDP5.8.tar.gz'
  md5 '37c15a3c6c3f13e31262f65ac4364b5e'

  def patches
    # remove -lg2c and #include malloc.h, not needed nowadays
    DATA
  end

  def install
    ENV['DSDPROOT'] = Dir.pwd
    system "make dsdpapi"
# bin contains just test files
#    bin.install Dir['bin/*']
    lib.install Dir['lib/*']
    include.install Dir['include/*']
  end

end

__END__
diff --git a/make.include b/make.include
index d1b85f0..98d518a 100644
--- a/make.include
+++ b/make.include
@@ -32,7 +32,7 @@ DSDPTIMER  = DSDP_TIME
 #DSDPTIMER  = DSDP_MS_TIME
 
 # STEP 3c: Add other compiler flags.
-DSDPCFLAGS = 
+DSDPCFLAGS = -DDSDP_TIME -I/usr/include/sys
 #DSDPCFLAGS = -Wall
 #DSDPCFLAGS = -DDSDPMATLAB
 #  Other flags concern BLAS and LAPACK libraries -- see next step.
@@ -55,7 +55,7 @@ CLINKER	= ${CC} ${OPTFLAGS}
 # Not needed to compile library or matlab executable
 # Needed to link DSDP library to the driver ( read SDPA files, maxcut example, ...)
 # Also include the math library and other libraries needed to link the BLAS to the C files that call them.
-LAPACKBLAS  = -llapack -lblas -lg2c -lm
+LAPACKBLAS  = -llapack -lblas -lm
 #LAPACKBLAS  = -L/usr/lib/ -llapack -lblas -lg2c -lm
 #LAPACKBLAS  = -L/home/benson/ATLAS/Linux_P4SSE2/lib -llapack -lcblas -lf77blas -latlas -lg2c -lm
 #LAPACKBLAS  = -L/sandbox/benson/ATLAS-3.6/lib/Linux_P4SSE2  -llapack -lcblas -lf77blas -latlas -lg2c -lm 
diff --git a/src/sys/dsdploginfo.c b/src/sys/dsdploginfo.c
index 9313549..cee4f93 100644
--- a/src/sys/dsdploginfo.c
+++ b/src/sys/dsdploginfo.c
@@ -6,7 +6,7 @@
 #include <stdarg.h>
 #include <sys/types.h>
 #include <stdlib.h>
-#include <malloc.h>
+//#include <malloc.h>
 #include "dsdpsys.h"
 #include "dsdpbasictypes.h"

