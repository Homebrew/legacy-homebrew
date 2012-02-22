require 'formula'

class Libsndfile < Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz'
  md5 'e2b7bb637e01022c7d20f95f9c3990a2'

  depends_on 'pkg-config' => :build

  def options
    [["--universal", "Build a universal binary."]]
  end

  def patches
    # libsndfile doesn't find Carbon.h using XCode 4.3:
    #=> As per: http://www.cocoabuilder.com/archive/xcode/244745-no-such-file-error.html
    #=> "CarbonCore is a subframework of CoreServices.  
    #=> When you use framework-style includes, by default 
    #=> the compiler only allows you to directly reference 
    #=> headers in top-level frameworks.""
    DATA
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/programs/sndfile-play.c 2011-03-28 01:15:31.000000000 -0400
+++ b/programs/sndfile-play.c 2012-02-22 11:32:20.000000000 -0500
@@ -58,7 +58,7 @@
  #include  <sys/soundcard.h>
 
 #elif (defined (__MACH__) && defined (__APPLE__))
- #include <Carbon.h>
+ #include <Carbon/Carbon.h>
  #include <CoreAudio/AudioHardware.h>
 
 #elif defined (HAVE_SNDIO_H)
