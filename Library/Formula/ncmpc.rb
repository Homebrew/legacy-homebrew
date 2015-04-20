require 'formula'

class Ncmpc < Formula
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  url 'http://www.musicpd.org/download/ncmpc/0/ncmpc-0.24.tar.gz'
  sha1 '15677a727920afff6485c9da30a4c7a522d4630a'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
