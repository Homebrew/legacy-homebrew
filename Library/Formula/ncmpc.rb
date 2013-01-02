require 'formula'

class Ncmpc < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  url 'http://downloads.sourceforge.net/musicpd/ncmpc-0.20.tar.bz2'
  sha1 'da106de4b11a48eb2d63619da1316713f95cc9cb'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
