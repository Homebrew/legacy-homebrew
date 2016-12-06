require 'formula'

class Aubio <Formula
  url 'http://aubio.org/pub/aubio-0.3.2.tar.gz'
  homepage 'http://aubio.org/'
  md5 'ffc3e5e4880fec67064f043252263a44'

  depends_on 'pkg-config'
  depends_on 'libsndfile'
  depends_on 'libsamplerate'
  depends_on 'fftw'

  def patches
    # remove -Wno-long-double which doesn't exist in gcc-4.x
    DATA
  end
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
__END__
diff --git a/configure b/configure
index 71531c9..fc79f04 100755
--- a/configure
+++ b/configure
@@ -20109,7 +20109,7 @@ fi
   ;;
 *darwin* | *rhapsody* | *macosx*)
     LDFLAGS="$LDFLAGS -lmx"
-    AUBIO_CFLAGS="$AUBIO_CFLAGS -Wno-long-double"
+    AUBIO_CFLAGS="$AUBIO_CFLAGS"
     CPPFLAGS="$CPPFLAGS -I${prefix}/include"
   { echo "$as_me:$LINENO: checking for library containing strerror" >&5
 echo $ECHO_N "checking for library containing strerror... $ECHO_C" >&6; }
