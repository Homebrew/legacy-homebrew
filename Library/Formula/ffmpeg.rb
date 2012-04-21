require 'formula'

def ffplay?
  ARGV.include? '--with-ffplay'
end

class Ffmpeg < Formula
  url 'http://ffmpeg.org/releases/ffmpeg-0.10.2.tar.bz2'
  homepage 'http://ffmpeg.org/'
  sha1 '743f44a71f93b14c9b26ca2424b0da8457cef4be'

  head 'git://git.videolan.org/ffmpeg.git'

  depends_on 'yasm' => :build
  depends_on 'x264' => :optional
  depends_on 'faac' => :optional
  depends_on 'lame' => :optional
  depends_on 'rtmpdump' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvpx' => :optional
  depends_on 'xvid' => :optional
  depends_on 'opencore-amr' => :optional
  depends_on 'libass' => :optional

  depends_on 'sdl' if ffplay?

  fails_with :llvm do
    cause 'Undefined symbols when linking libavfilter'
  end

  def options
    [
      ["--with-tools", "Install additional FFmpeg tools."],
      ["--with-ffplay", "Build ffplay."]
    ]
  end

  def patches
    # fixes OpenAL build for OS X.
    DATA
  end

  def install
    ENV.x11
    args = ["--prefix=#{prefix}",
            "--enable-shared",
            "--enable-gpl",
            "--enable-version3",
            "--enable-nonfree",
            "--enable-hardcoded-tables",
            "--enable-libfreetype",
            "--enable-openal",
            "--extra-ldflags=-framework OpenAL",
            "--cc=#{ENV.cc}"]

    args << "--enable-libx264" if Formula.factory('x264').installed?
    args << "--enable-libfaac" if Formula.factory('faac').installed?
    args << "--enable-libmp3lame" if Formula.factory('lame').installed?
    args << "--enable-librtmp" if Formula.factory('rtmpdump').installed?
    args << "--enable-libtheora" if Formula.factory('theora').installed?
    args << "--enable-libvorbis" if Formula.factory('libvorbis').installed?
    args << "--enable-libvpx" if Formula.factory('libvpx').installed?
    args << "--enable-libxvid" if Formula.factory('xvid').installed?
    args << "--enable-libopencore-amrnb" if Formula.factory('opencore-amr').installed?
    args << "--enable-libopencore-amrwb" if Formula.factory('opencore-amr').installed?
    args << "--enable-libass" if Formula.factory('libass').installed?
    args << "--disable-ffplay" unless ffplay?

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    if MacOS.leopard? or Hardware.is_32_bit?
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace 'config.mak' do |s|
        shflags = s.get_make_var 'SHFLAGS'
        if shflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
          s.change_make_var! 'SHFLAGS', shflags
        end
      end
    end

    system "make install"

    if ARGV.include? "--with-tools"
      system "make alltools"
      bin.install Dir['tools/*'].select {|f| File.executable? f}
    end
  end

end

__END__
diff -ru ffmpeg-0.10.2.orig/configure ffmpeg-0.10.2/configure
--- ffmpeg-0.10.2.orig/configure        2012-04-20 22:55:30.000000000 -0700
+++ ffmpeg-0.10.2/configure     2012-04-20 22:55:38.000000000 -0700
@@ -3167,11 +3167,12 @@
                         die "ERROR: libx264 version must be >= 0.118."; }
 enabled libxavs    && require  libxavs xavs.h xavs_encoder_encode -lxavs
 enabled libxvid    && require  libxvid xvid.h xvid_global -lxvidcore
-enabled openal     && { { for al_libs in "${OPENAL_LIBS}" "-lopenal" "-lOpenAL32"; do
-                        check_lib 'AL/al.h' alGetError "${al_libs}" && break; done } ||
+enabled openal     && { al_header='AL/al.h'; test $target_os = "darwin" && al_header='OpenAL/al.h';
+                      { { for al_libs in "${OPENAL_LIBS}" "-lopenal" "-lOpenAL32"; do
+                        check_lib "${al_header}" alGetError "${al_libs}" && break; done } ||
                         die "ERROR: openal not found"; } &&
-                      { check_cpp_condition "AL/al.h" "defined(AL_VERSION_1_1)" ||
-                        die "ERROR: openal version must be 1.1 or compatible"; }
+                      { check_cpp_condition "${al_header}" "defined(AL_VERSION_1_1)" ||
+                        die "ERROR: openal version must be 1.1 or compatible"; } }
 enabled mlib       && require  mediaLib mlib_types.h mlib_VectorSub_S16_U8_Mod -lmlib
 enabled openssl    && { check_lib openssl/ssl.h SSL_library_init -lssl -lcrypto ||
                         check_lib openssl/ssl.h SSL_library_init -lssl32 -leay32 ||
diff -ru ffmpeg-0.10.2.orig/libavdevice/openal-dec.c ffmpeg-0.10.2/libavdevice/openal-dec.c
--- ffmpeg-0.10.2.orig/libavdevice/openal-dec.c 2012-04-20 22:55:30.000000000 -0700
+++ ffmpeg-0.10.2/libavdevice/openal-dec.c      2012-04-20 22:56:10.000000000 -0700
@@ -21,8 +21,13 @@
  * OpenAL 1.1 capture device for libavdevice
  **/
 
+#ifdef __APPLE__
+#include <OpenAL/al.h>
+#include <OpenAL/alc.h>
+#else
 #include <AL/al.h>
 #include <AL/alc.h>
+#endif
 
 #include "libavutil/opt.h"
 #include "libavformat/internal.h"
