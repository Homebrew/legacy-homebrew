require 'formula'

class Vala < Formula
  version '0.14.0'
  head 'git://git.gnome.org/vala'
  url 'http://download.gnome.org/sources/vala/0.14/vala-0.14.0.tar.bz2'
  homepage 'http://live.gnome.org/Vala'
  sha256 '4cbca602e2e2a09803ae33fd7324219bc2c611db5a62a52e733e7d8806acb6f5'

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
