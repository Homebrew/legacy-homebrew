require 'formula'

class Mpd <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpd/0.16.1/mpd-0.16.1.tar.bz2'
  homepage 'http://mpd.wikia.com'
  md5 '4d07459125ab0154c5b4fe364331498a'

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
    args << "--disable-curl" if MACOS_VERSION <= 10.5
    args << "--enable-lastfm" if ARGV.include?("--lastfm")

    system "./configure", *args
    system "make install"
  end
end
