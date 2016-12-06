require 'formula'

class Gptsync < Formula
  url 'http://downloads.sourceforge.net/refit/refit-src-0.14.tar.gz'
  homepage 'http://refit.sourceforge.net/'
  md5 '16f02fa5b5decdee17eebd5cd863b3f0'
  version '0.14'

  def patches
	  # Fix used compiler
	  DATA
  end

  def install
    system "cd gptsync; make -f Makefile.unix"
	bin.install ['gptsync/gptsync', 'gptsync/showpart']
  end
end

__END__
diff --git a/gptsync/Makefile.unix b/gptsync/Makefile.unix
index a1d7282..b0c3121 100644
--- a/gptsync/Makefile.unix
+++ b/gptsync/Makefile.unix
@@ -20,7 +20,6 @@ LIBS     =
 
 system = $(shell uname)
 ifeq ($(system),Darwin)
-  CC        = gcc-4.0
   # TODO: re-enable this once the code is no longer little-endian specific
   #CFLAGS   += -arch i386 -arch ppc
   #LDFLAGS  += -arch i386 -arch ppc

