require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://sourceforge.net/projects/musicpd/files/mpd/0.17.2/mpd-0.17.2.tar.bz2'
  sha1 '5e7ccf39f44e51240f181c2e1d9af5a7dafb1f02'

  head "git://git.musicpd.org/master/mpd.git"

  option "lastfm", "Compile with experimental support for Last.fm radio"
  option 'libwrap', 'Enable support of TCP Wrappers (buggy on 10.7)'
  option 'libshout', 'Enable support Libshout for streaming default use built-in HTTP'
  option 'libao', 'Enable support ao output'
  option 'ffmpeg', 'Enable support ffmpeg decoder'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'libvorbis'
  depends_on 'libogg'
  depends_on 'flac'
  depends_on 'faad2'
  depends_on 'mpg123'
  depends_on 'lame'
  depends_on 'fluid-synth'
  depends_on 'libmms' => :optional
  depends_on 'libzzip' => :optional
  depends_on 'libshout' if build.include? 'libshout'
  depends_on 'libao' if build.include? 'libao'
  depends_on 'ffmpeg' if build.include? 'ffmpeg'

  def install
    system "./autogen.sh" if build.head?

    # make faad.h findable (when brew is used elsewhere than /usr/local/)
    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"

    args = ["--disable-debug", "--disable-dependency-tracking",
            "CC=gcc", "CXX=g++",
            "--prefix=#{prefix}",
            "--enable-bzip2",
            "--enable-flac",
            "--enable-mpg123",
            "--disable-vorbis",
            "--disable-mad",
            "--enable-fluidsynth",
            "--enable-zzip",
            "--enable-lame-encoder",
            "--enable-vorbis-encoder"]
    args << "--disable-curl" if MacOS.version == :leopard
    args << "--enable-lastfm" if build.include?("lastfm")
    args << "--disable-libwrap" unless build.include? 'libwrap'
    args << "--disable-shout" unless build.include? 'libshout'
    args << "--disable-ao" unless build.include? 'libao'
    args << "--disable-ffmpeg" unless build.include? 'ffmpeg'

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let's not do that
    system "make install"
  end
end

