require 'formula'

class Sox < Formula
  url 'http://downloads.sourceforge.net/project/sox/sox/14.3.2/sox-14.3.2.tar.gz'
  homepage 'http://sox.sourceforge.net/'
  md5 'e9d35cf3b0f8878596e0b7c49f9e8302'

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis' => :optional
  depends_on 'flac' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'libao' => :optional
  depends_on 'mad' # see commit message

  def patches
    # sox does not build against libav >= 0.7.0
    # http://sox.git.sourceforge.net/git/gitweb.cgi?p=sox/sox;a=commitdiff;h=c81a45e9b54fdb8c1835aeb575e748ec6d7c921d
    # Can be removed in the next release
    DATA
  end

  def install
    ENV.x11  # For libpng, used for the optional "spectrogram" effect.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gomp"
    system "make install"
  end
end

__END__
--- a/src/ffmpeg.c
+++ b/src/ffmpeg.c
@@ -50,6 +50,13 @@
 #include <ctype.h>
 #include "ffmpeg.h"
 
+#ifndef CODEC_TYPE_AUDIO
+#define CODEC_TYPE_AUDIO AVMEDIA_TYPE_AUDIO
+#endif
+#ifndef PKT_FLAG_KEY
+#define PKT_FLAG_KEY AV_PKT_FLAG_KEY
+#endif
+
 /* Private data for ffmpeg files */
 typedef struct {
   int audio_index;
