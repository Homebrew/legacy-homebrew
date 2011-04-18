require 'formula'

class Libgnomecanvas < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.1.tar.bz2'
  homepage 'http://www.linuxfromscratch.org/blfs/view/cvs/gnome/libgnomecanvas.html'
  md5 '362ab7b81024b3c3b4a712e7df01b169'

  depends_on 'intltool'
  depends_on 'libart'
  depends_on 'gettext'
  depends_on "libglade" if ARGV.include? "--with-glade"

  def options
    [
      ["--with-glade", "Glade support"],
    ]
  end

  def install

    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--disable-dependency-tracking"
    args << "--enable-glade" if ARGV.include? "--with-glade"

    system "./configure", *args
    system "make install"

  end
end
