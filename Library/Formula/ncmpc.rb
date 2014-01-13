require 'formula'

class Ncmpc < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  url 'http://www.musicpd.org/download/ncmpc/0/ncmpc-0.21.tar.bz2'
  sha1 'ec828bf17be6ab4c60c39bc91a3bd5cd93fac4a5'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
