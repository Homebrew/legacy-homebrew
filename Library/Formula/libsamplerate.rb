
class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "http://www.mega-nerd.com/SRC"
  url "http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz"
  sha256 "93b54bdf46d5e6d2354b7034395fe329c222a966790de34520702bb9642f1c06"

  bottle do
    cellar :any
    revision 1
    sha256 "d44b893117eb6f1f2e02c862997eb96f2f5855846370152bd56aab88fa8bea81" => :el_capitan
    sha256 "99c9fd31d3c17d23aef7cf3ef11406776fcf87509a8e480563723d7d2685f8b1" => :yosemite
    sha256 "dfefd0e6d5bb2344ef3980d5a2d738740c45f8227cff4f328113174cd1de6675" => :mavericks
    sha256 "6cc3d92e098322ca544c1e59a4dfc93b4c9ed393a476d0a9e788e726232c25f4" => :mountain_lion
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
