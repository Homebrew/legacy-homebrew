require 'formula'

class Finch < Formula
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  url 'http://sourceforge.net/projects/pidgin/files/Pidgin/2.10.4/pidgin-2.10.4.tar.bz2'
  md5 '264f9ae89742b8ee168306b85d2fb51e'


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
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtkui",
                          "--disable-gstreamer",
                          "--disable-vv",
                          "--disable-meanwhile",
                          "--disable-avahi",
                          "--disable-dbus"
    system "make install"
  end
end
