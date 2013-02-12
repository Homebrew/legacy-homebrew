require 'formula'

class Gtkdatabox < Formula
  homepage 'http://sourceforge.net/projects/gtkdatabox/'
  url 'http://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox/0.9.2.0/gtkdatabox-0.9.2.0.tar.gz'
  sha1 'a2cb25c1aa1b817283a3da9598d6d1d6e702d58f'

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
