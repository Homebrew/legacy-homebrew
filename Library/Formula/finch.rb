require 'formula'

# Finch is a command-line-only IM client from Pidgin
class Finch < Formula
  url 'http://sourceforge.net/projects/pidgin/files/Pidgin/2.7.10/pidgin-2.7.10.tar.bz2'
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  md5 '7514a5e25cc0061e7e1b7a1928c99247'

  depends_on 'pkg-config' => :build
  depends_on 'libidn'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gnutls'
  # configure picked up this dep on my machine - adamv
  # depends_on 'berkeley-db' => :optional

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
