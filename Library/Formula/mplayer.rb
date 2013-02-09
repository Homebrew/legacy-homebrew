require 'formula'

class Mplayer < Formula
  homepage 'http://www.mplayerhq.hu/'
  url 'http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.tar.xz'
  sha1 '913a4bbeab7cbb515c2f43ad39bc83071b2efd75'

  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => StrictSubversionDownloadStrategy

  option 'with-x', 'Build with X11 support'
  option 'without-osd', 'Build without OSD'
  option 'with-opus', 'Build with Opus support (currently requires --HEAD)'

  depends_on 'yasm' => :build
  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build if build.include? 'with-opus'
  depends_on :x11 if build.include? 'with-x'
  depends_on 'opus' if build.include? 'with-opus' and build.head?

  unless build.include? 'without-osd' or build.include? 'with-x'
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
    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    # In HEAD they have moved the source so the patch has changed.
    if build.head?
      "https://raw.github.com/gist/3801133/3bd547e198127e3ce2a83c1b481a8d6c6101013b/gistfile1.txt"
    else
      "https://raw.github.com/gist/3801137/87a7eb6e78827fb4ab549bd7b536e840a8992019/gistfile1.txt"
    end
  end

  def install
    # (A) Do not use pipes, per bug report and MacPorts
    # * https://github.com/mxcl/homebrew/issues/622
    # * http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # (B) Any kind of optimisation breaks the build
    # (C) It turns out that ENV.O1 fixes link errors with llvm.
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''
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

    args << "--enable-menu" unless build.include? 'without-osd'
    args << "--disable-x11" unless build.include? 'with-x'

    # GL headers are not correctly referenced since r35183 (when using HEAD)
    args << "--disable-gl" if build.head?

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end
