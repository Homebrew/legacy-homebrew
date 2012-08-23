require 'formula'

class Cogl < Formula
  homepage 'http://wiki.clutter-project.org/wiki/Cogl'
  url 'http://download.gnome.org/sources/cogl/1.10/cogl-1.10.4.tar.xz'
  sha256 '0b5c9989f1d07dbda000a68640eb7ebf734513d52e3707668c41eed19991adf9'

  head 'git://git.gnome.org/cogl'

  depends_on 'pkg-config' => :build

  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'cairo' # needs cairo-gobject

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make install"
  end
end
