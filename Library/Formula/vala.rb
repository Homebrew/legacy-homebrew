require 'formula'

class Vala <Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.8/vala-0.8.1.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 '3e105d7f39e55925299a3e6e82c32de7'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make" # Single step fails to compile for 0.8.0
    system "make install"
  end
end
