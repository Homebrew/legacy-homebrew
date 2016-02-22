class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "http://libquicktime.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  revision 2

  bottle do
    sha256 "d0762547198c0c6f40db52cdaae659d8b10b785afdeef46d52a95cd1430c4485" => :el_capitan
    sha256 "66ce6cc1c870267861fe1124c83604f5d15b43ab6fc27cff26f6980242b074ab" => :yosemite
    sha256 "9dd990b59f6a4ac957cc78e47a65b64ef026194326a2341b0915695398aa1c96" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "schroedinger" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libvorbis" => :optional

  # Fixes compilation with ffmpeg 2.x; applied upstream
  # https://sourceforge.net/p/libquicktime/mailman/message/30792767/
  patch :p0 do
    url "https://sourceforge.net/p/libquicktime/mailman/attachment/51812B9E.3090802%40mirriad.com/1/"
    sha256 "ae9773d11db5e60824d4cd8863daa6931e980b7385c595eabc37c7bb8319f225"
  end
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen",
                          "--without-x",
                          "--without-gtk"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/plugins/ffmpeg/audio.c b/plugins/ffmpeg/audio.c
index bc8d750..b185587 100644
--- a/plugins/ffmpeg/audio.c
+++ b/plugins/ffmpeg/audio.c
@@ -515,7 +515,7 @@ static int decode_chunk_vbr(quicktime_t * file, int track)
   if(!chunk_packets)
     return 0;
 
-  new_samples = num_samples + AVCODEC_MAX_AUDIO_FRAME_SIZE / (2 * track_map->channels);
+  new_samples = num_samples + 192000 / (2 * track_map->channels);
   
   if(codec->sample_buffer_alloc <
      codec->sample_buffer_end - codec->sample_buffer_start + new_samples)
@@ -671,7 +671,7 @@ static int decode_chunk(quicktime_t * file, int track)
    */
 
   num_samples += 8192;
-  new_samples = num_samples + AVCODEC_MAX_AUDIO_FRAME_SIZE / (2 * track_map->channels);
+  new_samples = num_samples + 192000 / (2 * track_map->channels);
   
   /* Reallocate sample buffer */
   
