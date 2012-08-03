require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.6/pidgin-2.10.6.tar.bz2'
  sha1 'a0532e7ba2acd205d6a5a4e3624156a980fe3d43'

  depends_on :x11
  depends_on 'gtk+'
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gnutls'

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
