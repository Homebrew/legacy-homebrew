require 'formula'

class Ffmbc < Formula
  homepage 'http://code.google.com/p/ffmbc/'
  url 'http://ffmbc.googlecode.com/files/FFmbc-0.7-rc7.tar.bz2'
  md5 '547bb7b7963224dd66dffa8b25e623b3'

  depends_on 'yasm' => :build
  depends_on 'x264' => :optional
  depends_on 'faac' => :optional
  depends_on 'lame' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvpx' => :optional
  depends_on 'xvid' => :optional

  def install
    ENV.x11
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-shared",
            "--enable-gpl",
            "--enable-nonfree",
            "--enable-libfreetype",
            "--cc=#{ENV.cc}"]

    args << "--enable-libx264" if Formula.factory('x264').installed?
    args << "--enable-libfaac" if Formula.factory('faac').installed?
    args << "--enable-libmp3lame" if Formula.factory('lame').installed?
    args << "--enable-libtheora" if Formula.factory('theora').installed?
    args << "--enable-libvorbis" if Formula.factory('libvorbis').installed?
    args << "--enable-libvpx" if Formula.factory('libvpx').installed?
    args << "--enable-libxvid" if Formula.factory('xvid').installed?

    system "./configure", *args
    system "make"

    # ffmbc's lib and bin names conflict with ffmpeg and libav
    # This formula will only install the commandline tools
    mv "ffprobe", "ffprobe-bc"
    bin.install "ffmbc", "ffprobe-bc"
    cd "doc" do
      mv "ffprobe.1", "ffprobe-bc.1"
      man1.install "ffmbc.1", "ffprobe-bc.1"
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
