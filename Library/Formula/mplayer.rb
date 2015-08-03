class Mplayer < Formula
  desc "UNIX movie player"
  homepage "http://www.mplayerhq.hu/"

  stable do
    url "http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.1.tar.xz"
    sha256 "ce8fc7c3179e6a57eb3a58cb7d1604388756b8a61764cc93e095e7aff3798c76"

    # Fix compilation on 10.9, adapted from upstream revision r36500
    patch do
      url "https://gist.githubusercontent.com/jacknagel/7441175/raw/37657c264a6a3bb4d30dee14538c367f7ffccba9/vo_corevideo.h.patch"
      sha256 "19296cbfa2d3b9af4f12d3fc8a4fdbf5b095bc85fc31b3328ab20bfbadb12b3d"
    end
  end

  bottle do
    revision 1
    sha1 "2c9bfd124fdd729bc8addd2ddfd45ed718c80e20" => :mavericks
    sha1 "ba213d5c1aadad6869cbb57f17f56971af8acffd" => :mountain_lion
    sha1 "7efc5960bc15c904a2893f23190d783b3d57d27a" => :lion
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"
    depends_on "subversion" => :build if MacOS.version <= :leopard

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  option "without-osd", "Build without OSD"

  depends_on "yasm" => :build
  depends_on "libcaca" => :optional
  depends_on :x11 => :optional

  deprecated_option "with-x" => "with-x11"

  if build.with?("osd") || build.with?("x11")
    # These are required for the OSD. We can get them from X11, or we can
    # build our own.
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libpng"
  end

  fails_with :clang do
    build 211
    cause "Inline asm errors during compile on 32bit Snow Leopard."
  end unless MacOS.prefer_64_bit?

  # ld fails with: Unknown instruction for architecture x86_64
  fails_with :llvm

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

    args << "--enable-menu" if build.with? "osd"
    args << "--disable-x11" if build.without? "x11"
    args << "--enable-freetype" if build.with?("osd") || build.with?("x11")
    args << "--enable-caca" if build.with? "libcaca"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -1532,8 +1532,6 @@
 fi
 
 if test "$ffmpeg_a" != "no" && ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone -b $FFBRANCH --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg ; then
         rm -rf ffmpeg
         echo "Failed to get a FFmpeg checkout"
