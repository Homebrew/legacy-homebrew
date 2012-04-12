require 'formula'

class Libpurple < Formula
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.7.3/pidgin-2.7.3.tar.bz2'
  homepage 'http://pidgin.im/'
  md5 'e4bbadadae85e5e008690b52dd51f102'

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
