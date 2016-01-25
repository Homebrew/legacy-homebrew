
class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "http://www.mega-nerd.com/SRC"
  url "http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz"
  sha256 "93b54bdf46d5e6d2354b7034395fe329c222a966790de34520702bb9642f1c06"

  bottle do
    cellar :any
    revision 2
    sha256 "7cdb2a6ae9047052461037e2a48742ca8a0caf72c5bce3eca856bbf24eeffd11" => :el_capitan
    sha256 "e50d3c4c47d61b844db05e1a37d299dbcaeec4236ebdff53ebd8e4dbedb32c29" => :yosemite
    sha256 "02bf6dca011543e5f49c42109462a5a94d02e2803f3258c0e38033f2205dcf1a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile" => :optional
  depends_on "fftw" => :optional

  # configure adds `/Developer/Headers/FlatCarbon` to the include, but this is
  # very deprecated. Correct the use of Carbon.h to the non-flat location.
  # See: https://github.com/Homebrew/homebrew/pull/10875
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # https://github.com/Homebrew/homebrew/issues/47133
    # unless this formula is built with libsndfile, the example program
    # is broken and hence, removed from installation.
    rm_f "#{bin}/sndfile-resample" if build.without? "libsndfile"
  end

  def caveats
    s = ""
    if build.without? "libsndfile"
      s += <<-EOS.undent
      Unless this formula is built with libsndfile, the example program,
      "sndfile-resample", is broken and hence, removed from installation.
      EOS
    end
    s
  end
end

__END__
--- a/examples/audio_out.c	2011-07-12 16:57:31.000000000 -0700
+++ b/examples/audio_out.c	2012-03-11 20:48:57.000000000 -0700
@@ -168,7 +168,7 @@
 
 #if (defined (__MACH__) && defined (__APPLE__)) /* MacOSX */
 
-#include <Carbon.h>
+#include <Carbon/Carbon.h>
 #include <CoreAudio/AudioHardware.h>
 
 #define	MACOSX_MAGIC	MAKE_MAGIC ('M', 'a', 'c', ' ', 'O', 'S', ' ', 'X')
