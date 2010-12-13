require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.6/libgee-0.6.0.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 '4eb513b23ab6ea78884989518a4acf6f'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
