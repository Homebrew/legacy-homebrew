require 'formula'

class Finch < Formula
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  url 'http://sourceforge.net/projects/pidgin/files/Pidgin/2.7.11/pidgin-2.7.11.tar.bz2'
  sha256 'a24e2c3118bd47983955d398c9cf5543c12e95527cdf7de9d273a6e92f9d160b'

  depends_on 'pkg-config' => :build
  depends_on 'libidn'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gnutls'

  def install
    # To get it to compile, had to configure without support for:
    #   * Sametime (meanwhile)
    #   * Bonjour (avahi)
    #   * Communicating with other programs (d-bus)
    #   * Perl scripting
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtkui",
                          "--disable-gstreamer",
                          "--disable-vv",
                          "--disable-meanwhile",
                          "--disable-avahi",
                          "--disable-dbus",
                          "--disable-perl"
    system "make install"
  end
end
