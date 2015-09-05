class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://live.gnome.org/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.2.tar.xz"
  sha256 "f20e5fbef8d1a2633033edbd886dd13146a1b948d1813a9c353a80a29295d1d0"

  bottle do
    sha1 "42f0f16ddfb2c40bc167be2a866e0bf0374123fc" => :yosemite
    sha1 "403c5a6c5795c088da09c3ac6a5f021a38dc93d3" => :mavericks
    sha1 "fd5b1e294c030e3c5f8c832c364fd50971538f4d" => :mountain_lion
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-gtk-doc-html"
    system "make", "install"
  end
end
