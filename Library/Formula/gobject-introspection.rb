require 'formula'

class GobjectIntrospection < Formula
  homepage 'http://live.gnome.org/GObjectIntrospection'
  url 'http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.34/gobject-introspection-1.34.1.tar.xz'
  sha256 'bf40470c863dbb292ec52d1e84495e9334ea954e3a0ee59d6ff5f8161ea53abd'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'libffi'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Tests require (at least) cairo, disable them.
                          "--disable-tests"
    system "make install"
  end
end
