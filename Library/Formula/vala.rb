require 'formula'

class Vala <Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.7/vala-0.7.10.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 '6e807644f500d6605a5ee4e1612dd187'

  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
