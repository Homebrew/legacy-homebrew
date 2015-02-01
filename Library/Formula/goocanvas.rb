require "formula"

class Goocanvas < Formula
  homepage "https://live.gnome.org/GooCanvas"
  url "http://ftp.gnome.org/pub/GNOME/sources/goocanvas/2.0/goocanvas-2.0.2.tar.xz"
  sha256 "f20e5fbef8d1a2633033edbd886dd13146a1b948d1813a9c353a80a29295d1d0"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    args = %W[
       --disable-dependency-tracking
       --prefix=#{prefix}
       --enable-introspection=yes
       --disable-silent-rules
       --disable-gtk-doc-html
    ]

    system "./configure", *args
    system "make", "install"
  end
end
