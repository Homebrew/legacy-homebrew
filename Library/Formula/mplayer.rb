class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://www.mplayerhq.hu/"

  stable do
    url "https://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.2.tar.xz"
    sha256 "ffe7f6f10adf2920707e8d6c04f0d3ed34c307efc6cd90ac46593ee8fba2e2b6"
  end

  bottle do
    sha256 "5504434dce05f51d0d6336426f64af559740203193f6f34d1ef250ebfe955d8f" => :el_capitan
    sha256 "6d6ccf0b963bc4a0edd48bc7d1e1008db888dc38b91fe85c6c58c5d6dded4f48" => :yosemite
    sha256 "d90208d62889b8c74d06917ba926f91fddb039ab15b27c825e4356b75b9d105b" => :mavericks
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
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
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
