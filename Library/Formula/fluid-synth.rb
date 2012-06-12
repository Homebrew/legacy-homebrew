require 'formula'

class FluidSynth < Formula
  homepage 'http://www.fluidsynth.org'
  url 'http://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.5/fluidsynth-1.1.5.tar.gz'
  sha1 '2f98696ca0a6757684f0a881bf92b3149536fdf2'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'libsndfile' => :optional

  # Fixes missing CoreAudio include on Lion.
  # Patch has been accepted upstream.
  # https://sourceforge.net/apps/trac/fluidsynth/ticket/105
  def patches; DATA; end

  def install
    mkdir 'build' do
      system "cmake", "..", "-Denable-framework=OFF", "-DLIB_SUFFIX=", *std_cmake_args
      system "make install"
    end
  end
end

__END__
--- a/src/drivers/fluid_coreaudio.c	2011-09-04 00:38:58.000000000 -0700
+++ b/src/drivers/fluid_coreaudio.c	2012-02-14 21:54:57.000000000 -0800
@@ -35,6 +35,7 @@
 #if COREAUDIO_SUPPORT
 #include <CoreServices/CoreServices.h>
 #include <CoreAudio/CoreAudioTypes.h>
+#include <CoreAudio/AudioHardware.h>
 #include <AudioUnit/AudioUnit.h>
 
 /*
