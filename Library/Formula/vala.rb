require 'formula'

class Vala < Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.15/vala-0.15.1.tar.xz'
  homepage 'http://live.gnome.org/Vala'
  md5 '639c8a85e184647a2c912a4f6ac28ed1'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make" # Single step fails to compile for 0.8.0
    system "make install"
  end

  def test
    system "#{bin}/valac --version"
  end
end
