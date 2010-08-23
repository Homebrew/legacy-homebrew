require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.5/libgee-0.5.2.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 'fc5a36eb5f61154a1456cbb8b1798e41'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
