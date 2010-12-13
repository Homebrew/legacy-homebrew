require 'formula'

class Ncmpc <Formula
  url 'http://downloads.sourceforge.net/project/musicpd/ncmpc/0.16.1/ncmpc-0.16.1.tar.bz2'
  homepage 'http://mpd.wikia.com/wiki/Client:Ncmpc'
  md5 'f3e53a379bd0bc82d315aa111bfdd17a'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
