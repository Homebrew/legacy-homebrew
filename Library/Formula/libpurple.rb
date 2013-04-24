require 'formula'

class Libpurple < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

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
  depends_on 'meanwhile' => :optional

  def install
    # Just build the library, so disable all this UI stuff
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-gtkui",
            "--disable-consoleui",
            "--disable-dbus",
            "--without-x",
            "--disable-gstreamer",
            "--disable-vv",
            "--disable-avahi",
            "--disable-perl",
            "--disable-doxygen"]
    if not build.with? 'meanwhile'
      args << "--disable-meanwhile"
    end
    system "./configure", *args
    system "make install"
  end
end
