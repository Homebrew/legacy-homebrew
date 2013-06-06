require 'formula'

class Mpd < Formula
  homepage 'http://mpd.wikia.com'
  url 'http://sourceforge.net/projects/musicpd/files/mpd/0.17.3/mpd-0.17.3.tar.bz2'
  sha1 'f684d73a7517371a4461afdb2439f9533b51a49d'

  head "git://git.musicpd.org/master/mpd.git"

  option "lastfm", "Compile with experimental support for Last.fm radio"
  option "libwrap", "Enable support of TCP Wrappers (buggy on 10.7)"
  option "enable-soundcloud", "Enable support for soundcloud.com"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'ffmpeg'
  depends_on 'flac'
  depends_on 'libshout'
  depends_on 'mad'
  depends_on 'lame'
  depends_on 'fluid-synth'
  depends_on 'libshout'
  depends_on 'faad2'
  depends_on 'libmms' => :optional
  depends_on 'libzzip' => :optional
  depends_on 'yajl' if build.include? 'enable-soundcloud'

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-bzip2
      --enable-ffmpeg
      --enable-flac
      --enable-shout
      --enable-fluidsynth
      --enable-lame-encoder
      --with-faad=#{Formula.factory("faad2").opt_prefix}
    ]

    args << "--disable-curl" if MacOS.version == :leopard
    args << "--disable-soundcloud" unless build.include? "enable-soundcloud"
    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.include? "lastfm"
    args << "--disable-libwrap" unless build.include? 'libwrap'

    system "./configure", *args
    system "make"
    ENV.j1 # Directories are created in parallel, so let's not do that
    system "make install"
  end
end
