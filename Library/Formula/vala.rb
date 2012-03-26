require 'formula'

class Vala < Formula
  homepage 'http://live.gnome.org/Vala'
  url 'http://download.gnome.org/sources/vala/0.15/vala-0.15.2.tar.xz'
  md5 '773562e7ba7bc0b40d87b7ad2db72443'

  head 'git://git.gnome.org/vala'

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
