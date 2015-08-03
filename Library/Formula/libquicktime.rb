class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "http://libquicktime.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  revision 1

  bottle do
    revision 1
    sha1 "15ba1227bfc6f81475ea8d57d59019d211117a82" => :yosemite
    sha1 "95a530bd3c46303f6df49fc0c0bb3d18b43706f2" => :mavericks
    sha1 "97260df51e133923c94c88aeee5d84a216617490" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "schroedinger" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libvorbis" => :optional

  # Fixes compilation with ffmpeg 2.x; applied upstream
  # http://sourceforge.net/p/libquicktime/mailman/message/30792767/
  patch :p0 do
    url "http://sourceforge.net/p/libquicktime/mailman/attachment/51812B9E.3090802%40mirriad.com/1/"
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
   
