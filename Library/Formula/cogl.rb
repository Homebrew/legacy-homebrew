require 'formula'

class Cogl < Formula
  homepage 'http://wiki.clutter-project.org/wiki/Cogl'
  url 'http://source.clutter-project.org/sources/cogl/1.10/cogl-1.10.2.tar.bz2'
  sha256 'ce4705693e98c064d5493913b2ffe23a49a9c83b644b2277d882b960369bc545'

  head 'git://git.gnome.org/cogl'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'pango'
  depends_on 'cairo' # needs cairo-gobject
  depends_on 'glib'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make install"
  end
end
