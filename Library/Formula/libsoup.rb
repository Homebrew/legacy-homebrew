require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.44/libsoup-2.44.2.tar.xz'
  sha256 'e7e4b5ab74a6c00fc267c9f5963852d28759ad3154dab6388e2d6e1962d598f3'

  depends_on 'xz' => :build
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
