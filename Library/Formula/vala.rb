require 'formula'

class Vala < Formula
  homepage 'http://live.gnome.org/Vala'
  url 'http://ftp.gnome.org/pub/gnome/sources/vala/0.22/vala-0.22.0.tar.xz'
  sha1 '1421a19c03ea565599e2df4ead6864cca761020a'

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
