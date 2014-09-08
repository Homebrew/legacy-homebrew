require 'formula'

class Libsamplerate < Formula
  homepage 'http://www.mega-nerd.com/SRC'
  url 'http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz'
  sha1 'e5fe82c4786be2fa33ca6bd4897db4868347fe70'

  bottle do
    cellar :any
    sha1 "d235c9d703076fc7021d7663a09ca2ffa496a190" => :mavericks
    sha1 "3a59f5ae0cbcfdd5501d98e7bd418b3564cd46c3" => :mountain_lion
    sha1 "a25e2123024d74546dce54994b1adf3e81ec6dd3" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile' => :optional
  depends_on 'fftw' => :optional

  # configure adds `/Developer/Headers/FlatCarbon` to the include, but this is
  # very deprecated. Correct the use of Carbon.h to the non-flat location.
  # See: https://github.com/Homebrew/homebrew/pull/10875
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
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
