require 'formula'

class Vala < Formula
  homepage 'http://live.gnome.org/Vala'
  url 'http://ftp.gnome.org/pub/gnome/sources/vala/0.23/vala-0.23.2.tar.xz'
  sha1 'dcd68492f14b9324d211695c3a310c9c2ba3d929'

  head 'git://git.gnome.org/vala'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make install"
  end

  def test
    system "#{bin}/valac", "--version"
  end
end
