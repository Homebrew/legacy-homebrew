require 'formula'

class Mplayer < Formula
  homepage 'http://www.mplayerhq.hu/'
  url 'http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.1.tar.xz'
  sha1 'ba2f3bd1442d04b17b0143680850273d928689c1'

  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => StrictSubversionDownloadStrategy

  option 'with-x', 'Build with X11 support'
  option 'without-osd', 'Build without OSD'

  depends_on 'yasm' => :build
  depends_on 'libcaca' => :optional
  depends_on :x11 if build.with? 'x'

  unless build.without? 'osd' or build.with? 'x'
    # These are required for the OSD. We can get them from X11, or we can
    # build our own.
    depends_on :fontconfig
    depends_on :freetype
  end

  fails_with :clang do
    build 211
    cause 'Inline asm errors during compile on 32bit Snow Leopard.'
  end unless MacOS.prefer_64_bit?

  def patches
    p = []
    if build.head?
      # When building SVN, configure prompts the user to pull FFmpeg from git.
      # Don't do that.
      p << DATA
    else
      # Fix compilation on 10.9, adapted from upstream revision r36500
      p << "https://gist.github.com/jacknagel/7441175/raw/37657c264a6a3bb4d30dee14538c367f7ffccba9/vo_corevideo.h.patch"
    end
    p
  end

  def install
    # It turns out that ENV.O1 fixes link errors with llvm.
    ENV.O1 if ENV.compiler == :llvm

    # we disable cdparanoia because homebrew's version is hacked to work on OS X
    # and mplayer doesn't expect the hacks we apply. So it chokes.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    # Disable openjpeg because it defines int main(), which hides mplayer's main().
    # This issue was reported upstream against openjpeg 1.5.0:
    # http://code.google.com/p/openjpeg/issues/detail?id=152
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
      --disable-libopenjpeg
    ]

    args << "--enable-menu" unless build.without? 'osd'
    args << "--disable-x11" unless build.with? 'x'
    args << "--enable-caca" if build.with? 'libcaca'

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end

__END__
diff --git a/configure b/configure
index a1fba5f..5deaa80 100755
--- a/configure
+++ b/configure
@@ -49,8 +49,6 @@ if test -e ffmpeg/mp_auto_pull ; then
 fi
 
 if ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg ; then
         rm -rf ffmpeg
         echo "Failed to get a FFmpeg checkout"
