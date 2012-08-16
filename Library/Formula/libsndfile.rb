require 'formula'

class Libsndfile < Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz'
  md5 'e2b7bb637e01022c7d20f95f9c3990a2'

  depends_on 'pkg-config' => :build

  option :universal

  def patches
    # libsndfile doesn't find Carbon.h using XCode 4.3:
    # fixed upstream: https://github.com/erikd/libsndfile/commit/d04e1de82ae0af48fd09d5cb09bf21b4ca8d513c
    DATA
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/programs/sndfile-play.c	2011-03-27 22:15:31.000000000 -0700
+++ b/programs/sndfile-play.c	2012-02-24 20:02:06.000000000 -0800
@@ -58,7 +58,6 @@
 	#include 	<sys/soundcard.h>
 
 #elif (defined (__MACH__) && defined (__APPLE__))
-	#include <Carbon.h>
 	#include <CoreAudio/AudioHardware.h>
 
 #elif defined (HAVE_SNDIO_H)
