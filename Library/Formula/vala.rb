require 'formula'

class Vala < Formula
  homepage 'http://live.gnome.org/Vala'
  url 'http://ftp.gnome.org/pub/gnome/sources/vala/0.22/vala-0.22.1.tar.xz'
  sha1 '440b63356a94565a3f58b9e2218e3bb31f02879b'

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
    system "#{bin}/valac", "--version"
  end
end
