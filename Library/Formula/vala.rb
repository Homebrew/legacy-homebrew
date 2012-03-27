require 'formula'

class Vala < Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.16/vala-0.16.0.tar.xz'
  homepage 'http://live.gnome.org/Vala'
  md5 '84b742e9cca4c90fde3026c3793c03c1'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make install"
  end

  def test
    system "#{bin}/valac --version"
  end
end
