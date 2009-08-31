require 'brewkit'

class Glib <Formula
  @url='http://ftp.acc.umu.se/pub/gnome/sources/glib/2.20/glib-2.20.5.tar.bz2'
  @md5='4c178b91d82ef80a2da3c26b772569c0'
  @homepage='http://www.gtk.org'

  def deps
    BinaryDep.new 'pkg-config'
    LibraryDep.new 'gettext'
  end

  def install
    # indeed, amazingly, -w causes gcc to emit spurious errors for this package!
    ENV.enable_warnings

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-rebuilds"
    system "make"
    system "make install"
    
    (prefix+'share'+'gtk-doc').rmtree
  end
end
