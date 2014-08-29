require 'formula'

class Ffmbc < Formula
  homepage 'http://code.google.com/p/ffmbc/'
  url 'https://ffmbc.googlecode.com/files/FFmbc-0.7-rc8.tar.bz2'
  sha1 '85a9673ac82a698bb96057fe027222efe6ebae28'
  revision 1

  bottle do
    sha1 "2ec4e61817f6dca744a74f366b9c9d8912fb3d89" => :mavericks
    sha1 "f9fd79a535a052862c3695a1525990c6df31e5d4" => :mountain_lion
    sha1 "bccbff468429c7af94e8047688b5452184826c22" => :lion
  end

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

  depends_on 'freetype' => :optional
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

    args << "--enable-libx264" if build.with? 'x264'
    args << "--enable-libfaac" if build.with? 'faac'
    args << "--enable-libmp3lame" if build.with? 'lame'
    args << "--enable-libxvid" if build.with? 'xvid'

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
  end

  def caveats
    <<-EOS.undent
      Due to naming conflicts with other FFmpeg forks, this formula installs
      only static binaries - no shared libraries are built.

      The `ffprobe` program has been renamed to `ffprobe-bc` to avoid name
      conflicts with the FFmpeg executable of the same name.
    EOS
  end

  test do
    system "#{bin}/ffmbc", "-h"
  end
end
