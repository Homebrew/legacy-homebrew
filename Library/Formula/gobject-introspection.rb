require 'formula'

class GobjectIntrospection < Formula
  homepage 'http://live.gnome.org/GObjectIntrospection'
  url 'http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.32/gobject-introspection-1.32.1.tar.xz'
  sha256 '44f3fb933f76e4728818cc360cb5f9e2edcbdf9bc8a8f9aded99b3e3ef5cb858'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'libffi'

  def options
    [["--universal", "Build universal binaries"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
