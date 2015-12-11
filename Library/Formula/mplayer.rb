class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://www.mplayerhq.hu/"
  revision 1

  stable do
    url "https://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.2.tar.xz"
    sha256 "ffe7f6f10adf2920707e8d6c04f0d3ed34c307efc6cd90ac46593ee8fba2e2b6"
  end

  bottle do
    sha256 "13be908b635ef84ab9a121f7e6787c20e6405bf645417e2f82f98192ea07c92e" => :el_capitan
    sha256 "c6d4cc95a347807eacf219ed68c6dffae61b5abffae65e938f8e2d959a84c1fb" => :yosemite
    sha256 "f9c8305916c2eb5363edc7715e499191e18eb39d6f8efd921d3a4d2881326ad9" => :mavericks
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"
    depends_on "subversion" => :build if MacOS.version <= :leopard

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  depends_on "yasm" => :build
  depends_on "libcaca" => :optional

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
    # and mplayer doesn't expect the hacks we apply. So it chokes. Only relevant
    # if you have cdparanoia installed.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    args = %W[
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
      --prefix=#{prefix}
      --disable-x11
    ]

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
