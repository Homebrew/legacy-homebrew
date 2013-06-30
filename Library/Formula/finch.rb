require 'formula'

class Finch < Formula
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  def install
    # Builds the UI
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-avahi",
                          "--disable-dbus",
                          "--disable-gstreamer",
                          "--disable-gtkui",
                          "--disable-meanwhile",
                          "--disable-vv",
                          "--disable-perl"
    system "make install"
  end
end
