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

  def patches
    { :p0 => DATA }
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-a52",
            "--enable-ffmpeg",
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
    system "make"
    system "make install"
  end
end

__END__

Update transcode to use non-deprecated methods and features

diff -u -rN transcode-1.1.5/Makefile transcode-1.1.5 fixed/Makefile
diff -u -rN export/export_ffmpeg.c.orig export/export_ffmpeg.c
--- export/export_ffmpeg.c.orig	2009-02-21 21:01:57.000000000 +0000
+++ export/export_ffmpeg.c	2011-08-10 10:41:14.000000000 +0100
@@ -643,8 +643,6 @@
 
     lavc_venc_context->bit_rate           = vob->divxbitrate * 1000;
     lavc_venc_context->bit_rate_tolerance = lavc_param_vrate_tolerance * 1000;
-    lavc_venc_context->mb_qmin            = lavc_param_mb_qmin;
-    lavc_venc_context->mb_qmax            = lavc_param_mb_qmax;
     lavc_venc_context->lmin= (int)(FF_QP2LAMBDA * lavc_param_lmin + 0.5);
     lavc_venc_context->lmax= (int)(FF_QP2LAMBDA * lavc_param_lmax + 0.5);
     lavc_venc_context->max_qdiff          = lavc_param_vqdiff;
diff -u -rN import/decode_lavc.c.orig import/decode_lavc.c
--- import/decode_lavc.c.orig	2009-03-28 08:39:08.000000000 +0000
+++ import/decode_lavc.c	2011-08-10 13:25:59.000000000 +0100
@@ -261,8 +261,13 @@
 
       //tc_log_msg(__FILE__, "SIZE: (%d) MP4(%d) blen(%d) BUF(%d) read(%ld)", len, mp4_size, buf_len, READ_BUFFER_SIZE, bytes_read);
       do {
-	  len = avcodec_decode_video(lavc_dec_context, &picture,
-		  &got_picture, buffer+buf_len, mp4_size-buf_len);
+          AVPacket *pkt;
+          av_init_packet(pkt);
+          pkt->stream_index = buffer;
+          pkt->pos = buf_len;
+          pkt->size = mp4_size-buf_len;
+	  len = avcodec_decode_video2(lavc_dec_context, &picture,
+		  &got_picture, pkt);
 
 	  if (len < 0) {
 	      tc_log_error(__FILE__, "frame decoding failed");
diff -u -rN import/import_ffmpeg.c.orig import/import_ffmpeg.c
--- import/import_ffmpeg.c.orig	2009-02-21 21:01:57.000000000 +0000
+++ import/import_ffmpeg.c	2011-08-10 13:27:29.000000000 +0100
@@ -543,8 +543,13 @@
 retry:
     do {
       TC_LOCK_LIBAVCODEC;
-      len = avcodec_decode_video(lavc_dec_context, &picture,
-			         &got_picture, buffer, bytes_read);
+      AVPacket *pkt;
+      av_init_packet(pkt);
+      pkt->stream_index = buffer;
+      pkt->size = bytes_read;
+      
+      len = avcodec_decode_video2(lavc_dec_context, &picture,
+			         &got_picture, pkt);
       TC_UNLOCK_LIBAVCODEC;
 
       if (len < 0) {
diff -u -rN import/probe_ffmpeg.c.orig import/probe_ffmpeg.c
--- import/probe_ffmpeg.c.orig	2009-03-28 08:39:08.000000000 +0000
+++ import/probe_ffmpeg.c	2011-08-10 13:29:35.000000000 +0100
@@ -47,7 +47,7 @@
     for (i = 0; i < ctx->nb_streams; i++) {
         st = ctx->streams[i];
 
-        if (st->codec->codec_type == CODEC_TYPE_VIDEO) {
+        if (st->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
             info->bitrate = st->codec->bit_rate / 1000;
             info->width = st->codec->width;
             info->height = st->codec->height;
@@ -65,7 +65,7 @@
     for (i = 0; i < ctx->nb_streams; i++) {
         st = ctx->streams[i];
 
-        if (st->codec->codec_type == CODEC_TYPE_AUDIO
+        if (st->codec->codec_type == AVMEDIA_TYPE_AUDIO
          && j < TC_MAX_AUD_TRACKS) {
             info->track[j].format = 0x1; /* known wrong */
             info->track[j].chan = st->codec->channels;
