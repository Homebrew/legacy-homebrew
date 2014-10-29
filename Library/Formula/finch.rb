require "formula"

class Finch < Formula
  homepage "http://developer.pidgin.im/wiki/Using%20Finch"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.10/pidgin-2.10.10.tar.bz2"
  sha1 "81267c35c8d27f2c62320b564fc11af2cc1f3a4a"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libidn"

  conflicts_with "pidgin", :because => "They are the same piece of software, sans GUI. Pidgin installs Finch"

  option "purple", "Only build libpurple"
  option "perl", "Build libpurple with perl support"

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
      --with-tclconfig=#{MacOS.sdk_path}/usr/lib
      --with-tkconfig=#{MacOS.sdk_path}/usr/lib
    ]

    args << "--disable-perl" unless build.include? "perl"

    if build.include? "purple"
      args << "--disable-consoleui"
    end

    system "./configure", *args
    system "make", "install"
  end
end
