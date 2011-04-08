require 'formula'

class Vala < Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.11/vala-0.11.7.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  md5 '5515f32552ee45ed5c7541c119009caa'

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
