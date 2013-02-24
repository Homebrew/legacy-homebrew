require 'formula'

class Ffmbc < Formula
  homepage 'http://code.google.com/p/ffmbc/'
  url 'http://ffmbc.googlecode.com/files/FFmbc-0.7-rc7.tar.bz2'
  sha1 '79d125cd5d420e61120e2a66b018b0be096ad088'

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.version >= :mountain_lion
  depends_on 'yasm' => :build

  depends_on 'x264' => :recommended
  depends_on 'faac' => :recommended
  depends_on 'lame' => :recommended
  depends_on 'xvid' => :recommended

  depends_on :freetype => :optional
  depends_on 'theora'  => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvpx' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-shared",
            "--enable-gpl",
            "--enable-nonfree",
            "--cc=#{ENV.cc}"]

    args << "--enable-libx264" unless build.without? 'x264'
    args << "--enable-libfaac" unless build.without? 'faac'
    args << "--enable-libmp3lame" unless build.without? 'lame'
    args << "--enable-libxvid" unless build.without? 'xvid'

    args << "--enable-libfreetype" if build.with? 'freetype'
    args << "--enable-libtheora" if build.with? 'theora'
    args << "--enable-libvorbis" if build.with? 'libvorbis'
    args << "--enable-libogg" if build.with? 'libogg'
    args << "--enable-libvpx" if build.with? 'libvpx'

    system "./configure", *args
    system "make"

    # ffmbc's lib and bin names conflict with ffmpeg and libav
    # This formula will only install the commandline tools
    mv "ffprobe", "ffprobe-bc"
    bin.install "ffmbc", "ffprobe-bc"
    cd "doc" do
      #mv "ffprobe.1", "ffprobe-bc.1"
      #man1.install "ffmbc.1", "ffprobe-bc.1"
    end
  end

  def caveats
    <<-EOS.undent
      Due to naming conflicts with other FFmpeg forks, this formula installs
      only static binaries - no shared libraries are built.

      The `ffprobe` program has been renamed to `ffprobe-bc` to avoid name
      conflicts with the FFmpeg executable of the same name.
    EOS
  end

  def test
    system "#{bin}/ffmbc", "-h"
  end
end
