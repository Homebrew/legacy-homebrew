require 'formula'

class Libpurple < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.4/pidgin-2.10.4.tar.bz2'
  sha1 'f9ce34e69f97bcd1bb216aefb6d687b5b47f0796'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'libidn'
  depends_on 'gnutls'

  def install
    # Just build the library, so disable all this UI stuff
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtkui",
                          "--disable-consoleui",
                          "--disable-dbus",
                          "--without-x",
                          "--disable-gstreamer",
                          "--disable-vv",
                          "--disable-meanwhile",
                          "--disable-avahi",
                          "--disable-perl",
                          "--disable-doxygen"
    system "make install"
  end
end
