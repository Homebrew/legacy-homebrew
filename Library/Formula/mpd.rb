require 'formula'

class Mpd <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpd/0.15.8/mpd-0.15.8.tar.bz2'
  homepage 'http://mpd.wikia.com'
  md5 '824e1ce46c0f468865d9e5e403cdaf5d'

  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'pkg-config'
  depends_on 'flac'
  depends_on 'libshout'
  depends_on 'fluid-synth'
  depends_on 'libcue' => :optional
  depends_on 'libmms' => :optional
  depends_on 'libzzip' => :optional

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-bzip2",
      "--enable-flac",
      "--enable-shout",
      "--enable-fluidsynth",
      "--enable-zip",
    ]
    configure_args << "--disable-curl" if MACOS_VERSION <= 10.5

    system "./configure", *configure_args
    system "make install"
  end
end
