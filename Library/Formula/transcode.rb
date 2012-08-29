require 'formula'

class Transcode < Formula
  url 'http://download.berlios.de/tcforge/transcode-1.1.5.tar.bz2'
  homepage 'http://www.transcoding.org/'
  md5 '41ac6b1c0fe30f3aab286e771fc31b9e'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'libmpeg2'
  depends_on 'a52dec'
  depends_on 'libdv'
  depends_on 'lzo'
  depends_on 'libogg'
  depends_on 'ffmpeg'
  depends_on 'imagemagick'
  depends_on 'libdvdread'
  depends_on 'libquicktime'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-a52",
            "--enable-faac",
            "--enable-imagemagick",
            "--enable-libdv",
            "--enable-ogg",
            "--enable-libquicktime",
            "--enable-theora",
            "--enable-vorbis",
            "--enable-libxml2",
            "--enable-lzo",
            "--enable-x264",
            "--enable-xvid",
            "--enable-sdl",
            "--without-x"]

    args << "--build=x86_64-apple-darwin10.0.0" if MacOS.prefer_64_bit?

    system './configure', *args
    system "make install"
  end

  def patches
    # Allow compilation to succeed with current ffmpeg
    # Taken from http://repository.slacky.eu/slackware64-13.37/multimedia/transcode/1.1.5/src/transcode-1.1.5-ffmpeg.patch
    # with fixes from http://www.funix.org/fr/linux/main-linux.php?ref=conversion&page=full for the lavc part
    DATA
  end
end

__END__
diff --git a/export/export_ffmpeg.c b/export/export_ffmpeg.c
index 847f633..2a17cec 100644
--- a/export/export_ffmpeg.c
+++ b/export/export_ffmpeg.c
@@ -643,8 +643,8 @@ MOD_init

     lavc_venc_context->bit_rate           = vob->divxbitrate * 1000;
     lavc_venc_context->bit_rate_tolerance = lavc_param_vrate_tolerance * 1000;
-    lavc_venc_context->mb_qmin            = lavc_param_mb_qmin;
-    lavc_venc_context->mb_qmax            = lavc_param_mb_qmax;
+/*  lavc_venc_context->mb_qmin            = lavc_param_mb_qmin;
+    lavc_venc_context->mb_qmax            = lavc_param_mb_qmax; */
     lavc_venc_context->lmin= (int)(FF_QP2LAMBDA * lavc_param_lmin + 0.5);
     lavc_venc_context->lmax= (int)(FF_QP2LAMBDA * lavc_param_lmax + 0.5);
     lavc_venc_context->max_qdiff          = lavc_param_vqdiff;
diff --git a/import/decode_lavc.c b/import/decode_lavc.c
index 2dea95d..737bf06 100644
--- a/import/decode_lavc.c
+++ b/import/decode_lavc.c
@@ -120,9 +120,11 @@ void decode_lavc(decode_t *decode)
   char               *yuv2rgb_buffer = NULL;
   AVCodec            *lavc_dec_codec = NULL;
   AVCodecContext     *lavc_dec_context;
+  AVPacket           *pkt;
   int                 x_dim = 0, y_dim = 0;
   int                 pix_fmt, frame_size = 0, bpp = 8;
   struct ffmpeg_codec *codec;
+  av_init_packet( &pkt );

   char   *fourCC = NULL;
   char *mp4_ptr=NULL;
@@ -261,8 +263,8 @@ void decode_lavc(decode_t *decode)

       //tc_log_msg(__FILE__, "SIZE: (%d) MP4(%d) blen(%d) BUF(%d) read(%ld)", len, mp4_size, buf_len, READ_BUFFER_SIZE, bytes_read);
       do {
-	  len = avcodec_decode_video(lavc_dec_context, &picture,
-		  &got_picture, buffer+buf_len, mp4_size-buf_len);
+	  len = avcodec_decode_video2(lavc_dec_context, &picture,
+		  &got_picture, &pkt);

	  if (len < 0) {
	      tc_log_error(__FILE__, "frame decoding failed");
diff --git a/import/probe_ffmpeg.c b/import/probe_ffmpeg.c
index 2b7486b..89e4a50 100644
--- a/import/probe_ffmpeg.c
+++ b/import/probe_ffmpeg.c
@@ -47,7 +47,7 @@ static void translate_info(const AVFormatContext *ctx, ProbeInfo *info)
     for (i = 0; i < ctx->nb_streams; i++) {
         st = ctx->streams[i];

-        if (st->codec->codec_type == CODEC_TYPE_VIDEO) {
+        if (st->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
             info->bitrate = st->codec->bit_rate / 1000;
             info->width = st->codec->width;
             info->height = st->codec->height;
@@ -65,7 +65,7 @@ static void translate_info(const AVFormatContext *ctx, ProbeInfo *info)
     for (i = 0; i < ctx->nb_streams; i++) {
         st = ctx->streams[i];

-        if (st->codec->codec_type == CODEC_TYPE_AUDIO
+        if (st->codec->codec_type == AVMEDIA_TYPE_AUDIO
          && j < TC_MAX_AUD_TRACKS) {
             info->track[j].format = 0x1; /* known wrong */
             info->track[j].chan = st->codec->channels;
