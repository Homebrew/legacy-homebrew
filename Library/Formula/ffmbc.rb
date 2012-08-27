require 'formula'

class Ffmbc < Formula
  homepage 'http://code.google.com/p/ffmbc/'
  url 'http://ffmbc.googlecode.com/files/FFmbc-0.7-rc7.tar.bz2'
  sha1 '79d125cd5d420e61120e2a66b018b0be096ad088'

  option "without-x264", "Disable H264 encoder"
  option "without-faac", "Disable AAC encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video format"

  option "with-freetype", "Enable FreeType"
  option "with-theora", "Enable Theora video format"
  option "with-libvorbis", "Enable Vorbis audio format"
  option "with-libogg", "Enable Ogg container format"
  option "with-libvpx", "Enable VP8 video format"

  # manpages won't be built without texi2html
  depends_on 'texi2html' => :build if MacOS.mountain_lion?
  depends_on 'yasm' => :build

  depends_on 'x264' unless build.include? 'without-x264'
  depends_on 'faac' unless build.include? 'without-faac'
  depends_on 'lame' unless build.include? 'without-lame'
  depends_on 'xvid' unless build.include? 'without-xvid'

  depends_on :freetype if build.include? 'with-freetype'
  depends_on 'theora' if build.include? 'with-theora'
  depends_on 'libvorbis' if build.include? 'with-libvorbis'
  depends_on 'libogg' if build.include? 'with-libogg'
  depends_on 'libvpx' if build.include? 'with-libvpx'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-shared",
            "--enable-gpl",
            "--enable-nonfree",
            "--cc=#{ENV.cc}"]

    args << "--enable-libx264" unless build.include? 'without-x264'
    args << "--enable-libfaac" unless build.include? 'without-faac'
    args << "--enable-libmp3lame" unless build.include? 'without-lame'
    args << "--enable-libxvid" unless build.include? 'without-xvid'

    args << "--enable-libfreetype" if build.include? 'with-freetype'
    args << "--enable-libtheora" if build.include? 'with-theora'
    args << "--enable-libvorbis" if build.include? 'with-libvorbis'
    args << "--enable-libogg" if build.include? 'with-libogg'
    args << "--enable-libvpx" if build.include? 'with-libvpx'

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
