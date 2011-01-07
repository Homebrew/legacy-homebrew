require 'formula'

class Vala <Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.11/vala-0.11.2.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 'ef0b6dc4a5fe4caa57e0d029bb9ea8dd'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make" # Single step fails to compile for 0.8.0
    system "make install"
  end

  def test
    system "valac --version"
  end
end
