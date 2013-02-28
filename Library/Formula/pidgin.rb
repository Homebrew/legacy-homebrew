require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "gtkspell"
  depends_on "gnutls"
  depends_on "nss" #nss installs keg_only as it conflicts with openssl
  depends_on "check" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-avahi",
                          "--disable-gstreamer", "--disable-meanwhile", "--disable-nm",
                          "--disable-sm", "--disable-gestures", "--disable-startup-notification",
                          "--disable-schemas-install", "--disable-vv", "--enable-nss",
                          "--disable-dependency-tracking", "--disable-idn", "--disable-dbus",
                          "--disable-screensaver", "--enable-gtkspell",
                          # nss installs keg_only due to conflict with openssl, hence:
                          "--with-nss-includes='#{Formula.factory('nss').include}'",
                          "--with-nss-libs='#{Formula.factory('nss').lib}'",
                          "--enable-consoleui", # remove if you do not want the fitch consoleui
                          "--prefix=#{prefix}"
    system "make install"
  end
end
