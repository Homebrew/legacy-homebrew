require 'formula'

class Libpurple < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.6/pidgin-2.10.6.tar.bz2'
  sha1 'a0532e7ba2acd205d6a5a4e3624156a980fe3d43'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libidn'
  depends_on 'gnutls'
  # guntls used to use libgcrypt, and the configure script links this
  # library when testing for gnutls, so include it as a build-time
  # dependency. See:
  # https://github.com/mxcl/homebrew/issues/17129
  depends_on 'libgcrypt' => :build

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
