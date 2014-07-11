require 'formula'

class Ncmpc < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  url 'http://www.musicpd.org/download/ncmpc/0/ncmpc-0.23.tar.gz'
  sha1 '801c9ff84ee091345dd6b33127c1c09e18dac01f'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
