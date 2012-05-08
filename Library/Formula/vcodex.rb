require 'formula'
require 'download_strategy'

class VcodexDownloadStrategy <CurlDownloadStrategy
  # downloading from AT&T requires using the following credentials
  def credentials
    'I accept www.research.att.com/license/att-src:.'
  end

  def _fetch
    curl @url, '--output', @tarball_path, '--user', credentials
  end
end

class Vcodex < Formula
  url 'http://www2.research.att.com/~gsf/download/tgz.att-src/vcodex.2005-05-22.tgz',
      :using => VcodexDownloadStrategy
  homepage 'http://www2.research.att.com/~gsf/download/ref/vcodex/vcodex.html'
  md5 'a773e26272568dbd182b7664802f7d29'
  version '2005-05-22'

  def patches; DATA; end

  def install
    # Vcodex makefiles do not work in parallel mode
    ENV.deparallelize
    # Vcodex code is not 64-bit clean
    ENV.m32
    # override Vcodex makefile flags
    inreplace Dir['src/**/Makefile'] do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXFLAGS", ENV.cflags
      s.change_make_var! "CCMODE", ""
    end
    # make all Vcodex stuff
    system "/bin/sh ./Runmake"
    # install manually
    bin.install Dir['bin/vc*']
    # put all includes into a directory of their own
    (include + "vcodex").install Dir['include/*.h']
    lib.install Dir['lib/*.a']
    man.install 'man/man3'
  end

  def caveats; <<-EOS.undent
    We agreed to the AT&T Source Code License for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end

__END__
diff --git a/src/lib/sfio/sfhdr.h b/src/lib/sfio/sfhdr.h
index 8bb64cc..d319c5a 100644
--- a/src/lib/sfio/sfhdr.h
+++ b/src/lib/sfio/sfhdr.h
@@ -1100,7 +1100,6 @@ extern Sfrsrv_t*	_sfrsrv _ARG_((Sfio_t*, ssize_t));
 extern int		_sfsetpool _ARG_((Sfio_t*));
 extern char*		_sfcvt _ARG_((Sfdouble_t,char*,size_t,int,int*,int*,int*,int));
 extern char**		_sfgetpath _ARG_((char*));
-extern Sfdouble_t	_sfdscan _ARG_((Void_t*, int(*)(Void_t*,int)));
 
 #if _BLD_sfio && defined(__EXPORT__)
 #define extern		__EXPORT__
diff --git a/src/lib/vcodex/Vchuff/vchbits.c b/src/lib/vcodex/Vchuff/vchbits.c
index 1bba200..c275bca 100644
--- a/src/lib/vcodex/Vchuff/vchbits.c
+++ b/src/lib/vcodex/Vchuff/vchbits.c
@@ -21,7 +21,7 @@ Void_t*	two;
 }
 
 #if __STD_C
-int vchbits(ssize_t* size, Vcbits_t* bits)
+ssize_t vchbits(ssize_t* size, Vcbits_t* bits)
 #else
 int vchbits(size, bits)
 ssize_t*	size;	/* encoding lengths of bytes	*/
diff --git a/src/lib/vcodex/Vchuff/vchsize.c b/src/lib/vcodex/Vchuff/vchsize.c
index e6df6b6..365eaaa 100644
--- a/src/lib/vcodex/Vchuff/vchsize.c
+++ b/src/lib/vcodex/Vchuff/vchsize.c
@@ -32,7 +32,7 @@ Void_t* two;
 }
 
 #if __STD_C
-int vchsize(ssize_t* freq, ssize_t* size, int* runb)
+ssize_t vchsize(ssize_t* freq, ssize_t* size, int* runb)
 #else
 int vchsize(freq, size, runb)
 ssize_t*	freq;	/* code frequencies	*/
diff --git a/src/lib/vcodex/features/vcodex b/src/lib/vcodex/features/vcodex
index 840a751..6d7747b 100644
--- a/src/lib/vcodex/features/vcodex
+++ b/src/lib/vcodex/features/vcodex
@@ -2,3 +2,4 @@ sys types
 sys times
 lib times
 hdr unistd
+hdr string
diff --git a/src/lib/vcodex/vchdr.h b/src/lib/vcodex/vchdr.h
index dcf5112..ec5e5ae 100644
--- a/src/lib/vcodex/vchdr.h
+++ b/src/lib/vcodex/vchdr.h
@@ -38,6 +38,10 @@ typedef struct _vcbuf_s
 #include	<varargs.h>
 #endif
 
+#if _hdr_string
+#include	<string.h>
+#endif
+
 #ifdef VMFL
 #include	<vmalloc.h>
 #endif
diff --git a/src/lib/vcodex/Vczip/vczip.c b/src/lib/vcodex/Vczip/vczip.c
index 385cb94..d6a2d72 100644
--- a/src/lib/vcodex/Vczip/vczip.c
+++ b/src/lib/vcodex/Vczip/vczip.c
@@ -11,6 +11,9 @@
 #if _hdr_unistd
 #include	<unistd.h>
 #endif
+#if _hdr_string
+#include	<string.h>
+#endif
 #if __STD_C
 #include	<stdarg.h>
 #else
