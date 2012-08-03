require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'gtk+'
  depends_on 'intltool'

  def install
    system "./configure", "--disable-debug", "--disable-gevolution",
                          "--enable-gnutls=yes", "--disable-gtkspell",
                          "--disable-vv", "--disable-meanwhile",
                          "--disable-avahi", "--disable-dbus",
                          "--disable-gstreamer-interfaces", "--disable-gstreamer",
                          "--disable-idn", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "pidgin --version"
  end
end
