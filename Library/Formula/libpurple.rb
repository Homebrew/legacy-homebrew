require 'formula'

class Libpurple <Formula
  url 'http://sourceforge.net/projects/pidgin/files/Pidgin/pidgin-2.6.6.tar.bz2'
  homepage 'http://pidgin.im/'
  md5 'b37ab6c52db8355e8c70c044c2ba17c1'

  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'libidn'
  depends_on 'gnutls'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-gtkui", "--disable-consoleui", "--disable-dbus", "--without-x",
                          "--disable-gstreamer", "--disable-vv", "--disable-meanwhile",
                          "--disable-avahi", "--disable-perl", "--disable-doxygen"
    system "make install"
  end
end
