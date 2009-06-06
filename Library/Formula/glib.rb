require 'brewkit'

class Glib <Formula
  @url='http://ftp.gnome.org/pub/gnome/sources/glib/2.20/glib-2.20.3.tar.bz2'
  @md5='1173688c58b4b62809c83bb07a2cf71a'
  @homepage='http://www.gtk.org'

  def install
    # indeed, amazingly, -w causes gcc to emit spurious errors!
    ENV['CFLAGS']=ENV['CFLAGS'].gsub '-w', ''

    system "./configure --disable-debug --prefix='#{prefix}' --disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
