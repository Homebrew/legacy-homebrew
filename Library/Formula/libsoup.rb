require 'formula'

class Libsoup < Formula
  homepage 'https://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.48/libsoup-2.48.1.tar.xz'
  sha256 '9b0d14b36e36a3131a06c6e3aa7245716e6904e3e636df81c0b6c8bd3f646f9a'

  bottle do
    revision 1
    sha1 "dc4dcb53c9da238e99feb055e70789eb54a2e98f" => :yosemite
    sha1 "4c7ab2c3b250ace75f099f80dd9ba36f4b277550" => :mavericks
    sha1 "693146c16d4105de3716252f2da9cf35156c0328" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib-networking'
  depends_on 'gnutls'
  depends_on 'sqlite'
  depends_on 'gobject-introspection' => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check"
    ]

    if build.with? "gobject-introspection"
      args << "--enable-introspection"
    else
      args << "--disable-introspection"
    end

    system "./configure", *args
    system "make install"
  end
end
