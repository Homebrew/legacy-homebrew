require 'formula'

class Vala < Formula
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.14/vala-0.14.1.tar.xz'
  homepage 'http://live.gnome.org/Vala'
  sha256 'bef8c803e6e84d6dd2c6e771b72245ae268f49f554f3d00b2c4a0b7a28f4a439'

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
