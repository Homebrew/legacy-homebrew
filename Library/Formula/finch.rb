require 'formula'

class Finch < Formula
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  url 'http://sourceforge.net/projects/pidgin/files/Pidgin/2.10.4/pidgin-2.10.4.tar.bz2'
  sha256 '8fbef835c8dfa2281532ad7064d664477d72015d6dcd4345362dcfe658aaee0e'

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
