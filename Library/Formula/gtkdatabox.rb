require 'formula'

class Gtkdatabox < Formula
  homepage 'http://sourceforge.net/projects/gtkdatabox/'
  url 'http://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox/0.9.1.3/gtkdatabox-0.9.1.3.tar.gz'
  sha1 '02380eeb755b885856253a1a71dd3e8109c201df'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # We need to re-enable deprecated features of gtk
    # in order to build without errors
    # Will be fixed in the next upstream release
    inreplace 'gtk/Makefile', '-DGTK_DISABLE_DEPRECATED', ''
    inreplace 'examples/Makefile', '-DGTK_DISABLE_DEPRECATED', ''

    system "make install"
  end
end
