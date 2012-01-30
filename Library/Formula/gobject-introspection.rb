require 'formula'

class GobjectIntrospection < Formula
  head 'git://git.gnome.org/gobject-introspection'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.31/gobject-introspection-1.31.10.tar.xz'
  homepage 'http://live.gnome.org/GObjectIntrospection'
  sha256 '6457e11a107830fc84020c4a975217f3dd2e74c8e0b2381b0ee91e8d9e9e5d5c'
  
  depends_on 'glib'
  depends_on 'libffi'
  
  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
