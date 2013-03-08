require 'formula'

class Libpurple < Formula
  homepage 'http://pidgin.im/'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  option 'perl', 'Build libpurple with perl support'

  def install
    # Just build the library, so disable all this UI stuff
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-consoleui
      --disable-dbus
      --disable-doxygen
      --disable-gstreamer
      --disable-gtkui
      --disable-meanwhile
      --disable-vv
      --without-x
    ]

    args << '--disable-perl' unless build.include? 'perl'

    system "./configure", *args
    system "make install"
  end
end
