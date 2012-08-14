require 'formula'

class Phash < Formula
  homepage 'http://www.phash.org/'
  url 'http://www.phash.org/releases/pHash-0.9.4.tar.gz'
  sha1 '9710b8a1d4d24e7fc3ac43c33eac8e89d9e727d7'

  depends_on 'cimg' unless  ARGV.include? "--disable-image-hash" and ARGV.include? "--disable-video-hash"
  depends_on 'ffmpeg' unless ARGV.include? "--disable-video-hash"

  unless ARGV.include? "--disable-audio-hash"
    depends_on 'libsndfile'
    depends_on 'libsamplerate'
    depends_on 'mpg123'
  end

  def options
    [
      ["--disable-image-hash", "Disable image hash"],
      ["--disable-video-hash", "Disable video hash"],
      ["--disable-audio-hash", "Disable audio hash"]
    ]
  end

  fails_with :clang do
    build 318
    cause "configure: WARNING: CImg.h: present but cannot be compiled"
  end

  # Fix compilation against ffmpeg 0.11.1. Incorporates Debian's fix:
  # https://launchpad.net/ubuntu/+source/libphash/0.9.4-1.2
  # Combined patch by @adamv
  def patches
    DATA
  end

  def install
    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --enable-shared
            ]

    # disable specific hashes if specified as an option
    args << "--disable-image-hash" if ARGV.include? "--disable-image-hash"
    args << "--disable-video-hash" if ARGV.include? "--disable-video-hash"
    args << "--disable-audio-hash" if ARGV.include? "--disable-audio-hash"

    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/src/cimgffmpeg.cpp b/src/cimgffmpeg.cpp
index fa7843c..6bed1eb 100644
--- a/src/cimgffmpeg.cpp
+++ b/src/cimgffmpeg.cpp
@@ -54,7 +54,7 @@ int ReadFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList, unsigned int low_
 	    av_register_all();
 	
 	    // Open video file
-	    if(av_open_input_file(&st_info->pFormatCtx, st_info->filename, NULL, 0, NULL)!=0)
+	    if(avformat_open_input(&st_info->pFormatCtx, st_info->filename, NULL, NULL)!=0)
 		return -1 ; // Couldn't open file
 	 
 	    // Retrieve stream information
@@ -67,7 +67,7 @@ int ReadFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList, unsigned int low_
 	    // Find the video stream
 	    for(i=0; i<st_info->pFormatCtx->nb_streams; i++)
 	    {
-		if(st_info->pFormatCtx->streams[i]->codec->codec_type==CODEC_TYPE_VIDEO) 
+		if(st_info->pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) 
 	        {
 		    st_info->videoStream=i;
 		    break;
@@ -123,6 +123,10 @@ int ReadFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList, unsigned int low_
 	int size = 0;
 	
 	AVPacket packet;
+
+	AVPacket avpacket;
+	av_init_packet(&avpacket);
+
 	int result = 1;
 	CImg<uint8_t> next_image;
 	SwsContext *c = sws_getContext(st_info->pCodecCtx->width, st_info->pCodecCtx->height, st_info->pCodecCtx->pix_fmt, st_info->width, st_info->height, ffmpeg_pixfmt , SWS_BICUBIC, NULL, NULL, NULL);
@@ -131,7 +135,10 @@ int ReadFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList, unsigned int low_
           if (result < 0)
 	      break;
     	  if(packet.stream_index==st_info->videoStream) {
-	      avcodec_decode_video(st_info->pCodecCtx, pFrame, &frameFinished,packet.data, packet.size);
+	      avpacket.data = packet.data;
+	      avpacket.size = packet.size;
+	      avpacket.flags = AV_PKT_FLAG_KEY;
+	      avcodec_decode_video2(st_info->pCodecCtx, pFrame, &frameFinished, &avpacket);
 	      if(frameFinished) {
 		  if (st_info->current_index == st_info->next_index){
 		      st_info->next_index += st_info->step;
@@ -199,7 +206,7 @@ int NextFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList)
 
 		av_log_set_level(AV_LOG_QUIET);
 		// Open video file
- 		if(av_open_input_file(&(st_info->pFormatCtx),st_info->filename,NULL,0,NULL)!=0){
+ 		if(avformat_open_input(&(st_info->pFormatCtx),st_info->filename,NULL,NULL)!=0){
 			return -1 ; // Couldn't open file
 		}
 	 
@@ -213,7 +220,7 @@ int NextFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList)
 		// Find the video stream
 		for(i=0; i< st_info->pFormatCtx->nb_streams; i++)
 		{
-			if(st_info->pFormatCtx->streams[i]->codec->codec_type==CODEC_TYPE_VIDEO) 
+			if(st_info->pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) 
 			{
 				st_info->videoStream=i;
 				break;
@@ -268,6 +275,10 @@ int NextFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList)
 	int frameFinished;
 	int size = 0;
 	AVPacket packet;
+
+	AVPacket avpacket;
+	av_init_packet(&avpacket);
+
 	int result = 1;
 	CImg<uint8_t> next_image;
 	SwsContext *c = sws_getContext(st_info->pCodecCtx->width, st_info->pCodecCtx->height, st_info->pCodecCtx->pix_fmt, st_info->width, st_info->height, ffmpeg_pixfmt , SWS_BICUBIC, NULL, NULL, NULL);
@@ -279,8 +290,10 @@ int NextFrames(VFInfo *st_info, CImgList<uint8_t> *pFrameList)
 			break;
 		if(packet.stream_index == st_info->videoStream) {
 			
-		    avcodec_decode_video(st_info->pCodecCtx, pFrame, &frameFinished,
-		                         packet.data,packet.size);
+		    avpacket.data = packet.data;
+		    avpacket.size = packet.size;
+		    avpacket.flags = AV_PKT_FLAG_KEY;
+		    avcodec_decode_video2(st_info->pCodecCtx, pFrame, &frameFinished, &avpacket);
  
 		    if(frameFinished) {
 		    	if (st_info->current_index == st_info->next_index)
@@ -336,7 +349,7 @@ int GetNumberStreams(const char *file)
 	 av_log_set_level(AV_LOG_QUIET);
 	 av_register_all();
 	// Open video file
-	if (av_open_input_file(&pFormatCtx, file, NULL, 0, NULL))
+	if (avformat_open_input(&pFormatCtx, file, NULL, NULL))
 	  return -1 ; // Couldn't open file
 		 
 	// Retrieve stream information
@@ -354,7 +367,7 @@ long GetNumberVideoFrames(const char *file)
     av_log_set_level(AV_LOG_QUIET);
 	av_register_all();
 	// Open video file
-	if (av_open_input_file(&pFormatCtx, file, NULL, 0, NULL))
+	if (avformat_open_input(&pFormatCtx, file, NULL, NULL))
 	  return -1 ; // Couldn't open file
 			 
 	// Retrieve stream information
@@ -365,7 +378,7 @@ long GetNumberVideoFrames(const char *file)
 	int videoStream=-1;
 	for(unsigned int i=0; i<pFormatCtx->nb_streams; i++)
 	{
-	     if(pFormatCtx->streams[i]->codec->codec_type==CODEC_TYPE_VIDEO) 
+	     if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) 
 	     {
 		    videoStream=i;
 		    break;
@@ -396,7 +409,7 @@ float fps(const char *filename)
 	AVFormatContext *pFormatCtx;
 	
 	// Open video file
-	if (av_open_input_file(&pFormatCtx, filename, NULL, 0, NULL))
+	if (avformat_open_input(&pFormatCtx, filename, NULL, NULL))
 	  return -1 ; // Couldn't open file
 				 
 	// Retrieve stream information
@@ -407,7 +420,7 @@ float fps(const char *filename)
 	int videoStream=-1;
 	for(unsigned int i=0; i<pFormatCtx->nb_streams; i++)
 	{
-		     if(pFormatCtx->streams[i]->codec->codec_type==CODEC_TYPE_VIDEO) 
+		     if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) 
 		     {
 			    videoStream=i;
 			    break;
