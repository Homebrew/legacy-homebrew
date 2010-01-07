require 'formula'

class Mpd <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/mpd/0.15.7/mpd-0.15.7.tar.bz2'
  homepage 'http://mpd.wikia.com'
  md5 'ecec7f0bdfe8024cc4daa53e4cc476a4'

  depends_on 'glib'
  depends_on 'libid3tag'
  depends_on 'pkg-config'
  depends_on 'flac'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-curl", "--enable-flac"
    system "make install"
  end
end
