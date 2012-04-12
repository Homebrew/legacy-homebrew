require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://sourceforge.net/projects/musicpd/files/mpd/0.16.8/mpd-0.16.8.tar.bz2'
  sha1 '977c80db8dc64e65c2bc523f69a9a7a71adca2b1'

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
