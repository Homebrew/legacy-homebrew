require 'formula'

class Libav < Formula
  homepage 'https://libav.org/'
  url 'http://libav.org/releases/libav-9.9.tar.xz'
  sha1 '5093a924543305b64d48fcd73b193ad4e7a0fa7f'

  option "without-faac", "Disable AAC encoder via faac"
  option "without-lame", "Disable MP3 encoder via libmp3lame"
  option "without-x264", "Disable H.264 encoder via x264"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder via xvid"

  option "with-opencore-amr", "Enable AMR-NB de/encoding and AMR-WB decoding " +
    "via libopencore-amrnb and libopencore-amrwb"
  option "with-openjpeg", "Enable JPEG 2000 de/encoding via OpenJPEG"
  option "with-speex", "Enable Speex de/encoding via libspeex"
  option "with-theora", "Enable Theora encoding via libtheora"
  option "with-libvorbis", "Enable Vorbis encoding via libvorbis"
  option "with-libvpx", "Enable VP8 de/encoding via libvpx"

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build
  depends_on 'xz' => :build

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.version >= :mountain_lion

  depends_on 'faac' => :recommended
  depends_on 'lame' => :recommended
  depends_on 'x264' => :recommended
  depends_on 'xvid' => :recommended

  depends_on :freetype => :optional
  depends_on 'gnutls' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libvpx' => :optional
  depends_on 'opencore-amr' => :optional
  depends_on 'openjpeg' => :optional
  depends_on 'speex' => :optional
  depends_on 'theora' => :optional

  def patches
    DATA
  end

  def install
    args = [
      "--disable-debug",
      "--disable-shared",
      "--prefix=#{prefix}",
      "--enable-doc",
      "--enable-gpl",
      "--enable-nonfree",
      "--enable-version3",
      "--cc=#{ENV.cc}",
      "--host-cflags=#{ENV.cflags}",
      "--host-ldflags=#{ENV.ldflags}"
    ]

    args << "--enable-libfaac" if build.with? 'faac'
    args << "--enable-libmp3lame" if build.with? 'lame'
    args << "--enable-libx264" if build.with? 'x264'
    args << "--enable-libxvid" if build.with? 'xvid'

    args << "--enable-libvpx" if build.with? 'libvpx'
    args << "--enable-gnutls" if build.with? 'gnutls'
    args << "--enable-libopenjpeg" if build.with? 'openjpeg'
    args << "--enable-libfreetype" if build.with? 'freetype'
    args << "--enable-libspeex" if build.with? 'speex'
    args << "--enable-libvorbis" if build.with? 'libvorbis'
    args << "--enable-libtheora" if build.with? 'theora'
    args << "--enable-libopencore-amrnb" if build.with? 'opencore-amr'
    args << "--enable-libopencore-amrwb" if build.with? 'opencore-amr'

    system "./configure", *args

    system "make"

    bin.install 'avconv', 'avprobe'
    man1.install 'doc/avconv.1', 'doc/avprobe.1'
  end

  test do
    system "#{bin}/avconv -h"
  end
end

__END__
# Patch configure to use require_pkg_config so it will use correct include path.
#
# Upstream bugs relating to this patch:
#
# https://bugzilla.libav.org/show_bug.cgi?id=387
# https://bugzilla.libav.org/show_bug.cgi?id=405
# https://bugzilla.libav.org/show_bug.cgi?id=569
diff --git a/tmp/libav-9.9/configure b/configure
index 6ab04ae..5ccd2b7 100755
--- a/tmp/libav-9.9/configure
+++ b/configure
@@ -3488,7 +3488,7 @@ enabled libmp3lame && require  "libmp3lame >= 3.98.3" lame/lame.h lame_set_VBR_q
 enabled libopencore_amrnb  && require libopencore_amrnb opencore-amrnb/interf_dec.h Decoder_Interface_init -lopencore-amrnb
 enabled libopencore_amrwb  && require libopencore_amrwb opencore-amrwb/dec_if.h D_IF_init -lopencore-amrwb
 enabled libopencv  && require_pkg_config opencv opencv/cv.h cvCreateImageHeader
-enabled libopenjpeg && require libopenjpeg openjpeg.h opj_version -lopenjpeg
+enabled libopenjpeg && require_pkg_config libopenjpeg openjpeg.h opj_version
 enabled libopus    && require_pkg_config opus opus_multistream.h opus_multistream_decoder_create
 enabled libpulse && require_pkg_config libpulse-simple pulse/simple.h pa_simple_new
 enabled librtmp    && require_pkg_config librtmp librtmp/rtmp.h RTMP_Socket
