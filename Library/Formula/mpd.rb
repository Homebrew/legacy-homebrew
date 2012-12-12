require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://sourceforge.net/projects/musicpd/files/mpd/0.17.2/mpd-0.17.2.tar.bz2'
  sha1 '5e7ccf39f44e51240f181c2e1d9af5a7dafb1f02'

  head "git://git.musicpd.org/master/mpd.git"

  option "lastfm", "Compile with experimental support for Last.fm radio"
  option 'libwrap', 'Enable support of TCP Wrappers (buggy on 10.7)'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'ffmpeg'
  depends_on 'flac'
  depends_on 'libshout'
  depends_on 'mad'
  depends_on 'lame'
  depends_on 'faad2' => :optional
  depends_on 'fluid-synth'
  depends_on 'libmms' => :optional
  depends_on 'libzzip' => :optional

  def install
    system "./autogen.sh" if build.head?

    # make faad.h findable (when brew is used elsewhere than /usr/local/)
    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-bzip2",
            "--enable-ffmpeg",
            "--enable-flac",
            "--enable-shout",
            "--enable-fluidsynth",
            "--enable-zzip",
            "--enable-lame-encoder"]
    args << "--disable-curl" if MacOS.version == :leopard
    args << "--enable-lastfm" if build.include?("lastfm")
    args << '--disable-libwrap' unless build.include? 'libwrap'

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let's not do that
    system "make install"
  end
end
