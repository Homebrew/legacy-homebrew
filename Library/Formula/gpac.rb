require 'formula'

# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  homepage 'http://gpac.wp.mines-telecom.fr/'
  url 'https://downloads.sourceforge.net/gpac/gpac-0.5.0.tar.gz'
  sha1 '48ba16272bfa153abb281ff8ed31b5dddf60cf20'

  head 'https://gpac.svn.sourceforge.net/svnroot/gpac/trunk/gpac'

  depends_on :x11 => :recommended

  depends_on 'pkg-config' => :build
  depends_on 'a52dec' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'faad2' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'mad' => :optional
  depends_on 'sdl' => :optional
  depends_on 'theora' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'openjpeg' => :optional

  # Fixes build against ffmpeg 2.x; backported from upstream SVN
  patch :DATA

  def install
    ENV.deparallelize

    args = ["--disable-wx",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    if build.with? 'x11'
      # gpac build system is barely functional
      args << "--extra-cflags=-I#{MacOS::X11.include}"
      # Force detection of X libs on 64-bit kernel
      args << "--extra-ldflags=-L#{MacOS::X11.lib}"
    end

    chmod 0700, "configure"
    system "./configure", *args
    system "make"
    system "make install"
  end
end

__END__
diff --git a/modules/ffmpeg_in/ffmpeg_decode.c b/modules/ffmpeg_in/ffmpeg_decode.c
index db7d65e..387966b 100644
--- a/modules/ffmpeg_in/ffmpeg_decode.c
+++ b/modules/ffmpeg_in/ffmpeg_decode.c
@@ -37,7 +37,11 @@
 #undef USE_AVCODEC2
 #endif
 
-
+#if (LIBAVCODEC_VERSION_MAJOR >= 55)
+#define USE_AVCTX3
+#elif (LIBAVCODEC_VERSION_MAJOR >= 54) && (LIBAVCODEC_VERSION_MINOR >= 35)
+#define USE_AVCTX3
+#endif
 
 /**
  * Allocates data for FFMPEG decoding
@@ -169,8 +173,12 @@ static GF_Err FFDEC_AttachStream(GF_BaseDecoder *plug, GF_ESD *esd)
 		frame = &ffd->base_frame;
 	}
 	if (!(*ctx)){
-	  *ctx = avcodec_alloc_context();
-	}
+#ifdef USE_AVCTX3
+	  *ctx = avcodec_alloc_context3(NULL);
+#else
+ 	  *ctx = avcodec_alloc_context();
+#endif
+        }
 
 	/*private FFMPEG DSI*/
 	if (ffd->oti == GPAC_OTI_MEDIA_FFMPEG) {
@@ -317,7 +325,12 @@ static GF_Err FFDEC_AttachStream(GF_BaseDecoder *plug, GF_ESD *esd)
 		(*ctx)->pix_fmt = ffd->raw_pix_fmt;
 		if ((*ctx)->extradata && strstr((*ctx)->extradata, "BottomUp")) ffd->flipped = 1;
 	} else {
-		if (avcodec_open((*ctx), (*codec) )<0) return GF_NON_COMPLIANT_BITSTREAM;
+#ifdef USE_AVCTX3
+		if (! (*codec) || (avcodec_open2(ctx, *codec, NULL)<0)) return GF_NON_COMPLIANT_BITSTREAM;
+#else
+ 		if (! (*codec) || (avcodec_open(ctx, *codec)<0)) return GF_NON_COMPLIANT_BITSTREAM;
+#endif
+
 	}
 
 	/*setup audio streams*/
@@ -611,10 +624,11 @@ static GF_Err FFDEC_ProcessData(GF_MediaDecoder *plug,
 		if (ffd->frame_start>inBufferLength) ffd->frame_start = 0;
 
 redecode:
-		gotpic = AVCODEC_MAX_AUDIO_FRAME_SIZE;
 #ifdef USE_AVCODEC2
+		gotpic = 0;
 		len = avcodec_decode_audio3(ctx, (short *)ffd->audio_buf, &gotpic, &pkt);
 #else
+		gotpic = AVCODEC_MAX_AUDIO_FRAME_SIZE;
 		len = avcodec_decode_audio2(ctx, (short *)ffd->audio_buf, &gotpic, inBuffer + ffd->frame_start, inBufferLength - ffd->frame_start);
 #endif
 		if (len<0) { ffd->frame_start = 0; return GF_NON_COMPLIANT_BITSTREAM; }
@@ -749,7 +763,12 @@ redecode:
 			here this means the DSI was broken, so no big deal*/
 			avcodec_close(ctx);
 			*codec = avcodec_find_decoder(CODEC_ID_H263);
+#ifdef USE_AVCTX3
+			if (! (*codec) || (avcodec_open2(ctx, *codec, NULL)<0)) return GF_NON_COMPLIANT_BITSTREAM;
+#else
 			if (! (*codec) || (avcodec_open(ctx, *codec)<0)) return GF_NON_COMPLIANT_BITSTREAM;
+#endif
+
 #if USE_AVCODEC2
 			if (avcodec_decode_video2(ctx, frame, &gotpic, &pkt) < 0) {
 #else
@@ -759,7 +778,11 @@ redecode:
 				avcodec_close(ctx);
 				*codec = avcodec_find_decoder(old_codec);
 				assert(*codec);
+#ifdef USE_AVCTX3
+				avcodec_open2(ctx, *codec, NULL);
+#else
 				avcodec_open(ctx, *codec);
+#endif
 				return GF_NON_COMPLIANT_BITSTREAM;
 			}
 		}
diff --git a/modules/ffmpeg_in/ffmpeg_demux.c b/modules/ffmpeg_in/ffmpeg_demux.c
index 0f8ee50..8bb7948 100644
--- a/modules/ffmpeg_in/ffmpeg_demux.c
+++ b/modules/ffmpeg_in/ffmpeg_demux.c
@@ -52,6 +52,11 @@
 #define AVERROR_NOFMT AVERROR(EINVAL)
 #endif /* AVERROR_NOFMT */
 
+#if (LIBAVFORMAT_VERSION_MAJOR >= 54) && (LIBAVFORMAT_VERSION_MINOR >= 20)
+#define av_find_stream_info(__c)        avformat_find_stream_info(__c, NULL)
+#define FF_API_FORMAT_PARAMETERS        1
+#endif
+
 static u32 FFDemux_Run(void *par)
 {
 	AVPacket pkt;
diff --git a/modules/ffmpeg_in/ffmpeg_in.h b/modules/ffmpeg_in/ffmpeg_in.h
index 4b2bdf5..2cf8304 100644
--- a/modules/ffmpeg_in/ffmpeg_in.h
+++ b/modules/ffmpeg_in/ffmpeg_in.h
@@ -117,7 +117,7 @@ typedef struct
 
 	/*for audio packed frames*/
 	u32 frame_start;
-	char audio_buf[AVCODEC_MAX_AUDIO_FRAME_SIZE];
+	char audio_buf[19200];
 	Bool check_h264_isma;
 
 	u32 base_ES_ID;
