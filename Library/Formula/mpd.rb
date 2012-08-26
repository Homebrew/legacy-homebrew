require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://sourceforge.net/projects/musicpd/files/mpd/0.17/mpd-0.17.tar.bz2'
  sha1 '36201f32ca5729b62b0e6cbddb19ade20ee3f7d7'

  head "git://git.musicpd.org/master/mpd.git"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'flac'
  depends_on 'libshout'
  depends_on 'mad'
  depends_on 'lame'
  depends_on 'faad2' => :optional
  depends_on 'fluid-synth'
  depends_on 'libcue' => :optional
  depends_on 'libmms' => :optional
  depends_on 'libzzip' => :optional

  def options
    [["--lastfm", "Compile with experimental support for Last.fm radio"]]
  end

  def install
    system "./autogen.sh" if ARGV.build_head?

    # make faad.h findable (when brew is used elsewhere than /usr/local/)
    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-bzip2",
            "--enable-flac",
            "--enable-shout",
            "--enable-fluidsynth",
            "--enable-zip",
            "--enable-lame-encoder"]
    args << "--disable-curl" if MacOS.leopard?
    args << "--enable-lastfm" if ARGV.include?("--lastfm")

    system "./configure", *args
    system "make install"
  end
end
