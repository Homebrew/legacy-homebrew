require 'formula'

class Finch < Formula
  homepage 'http://developer.pidgin.im/wiki/Using%20Finch'
  url 'http://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.7/pidgin-2.10.7.tar.bz2'
  sha1 '01bc06e3a5712dded3ad4a4913ada12a3cd01e15'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  option 'purple' 'Only build libpurple'
  option 'perl', 'Build libpurple with perl support'

  def install
    # Common options
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-dbus
      --disable-doxygen
      --disable-gstreamer
      --disable-gtkui
      --disable-meanwhile
      --disable-vv
      --without-x
    ]

    args << '--disable-perl' unless build.include? 'perl'

    if build.include? 'purple'
      args << '--disable-consoleui'
    end

    system "./configure", *args
    system "make install"
  end
end
