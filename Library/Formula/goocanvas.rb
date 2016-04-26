class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://live.gnome.org/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.2.tar.xz"
  sha256 "f20e5fbef8d1a2633033edbd886dd13146a1b948d1813a9c353a80a29295d1d0"

  bottle do
    sha256 "ac7dc165c731d18f5de7b451bc14bdc17d198dad2b528018e94043e4c86a219d" => :el_capitan
    sha256 "19136fea9c0f7175b7a88607b7501eec1588ef6734a84a00f8c953c0008cc7c0" => :yosemite
    sha256 "6c54975917e2110ec90c4c5dda28e364a6a25ad68c1e23e73f151daae228e5bd" => :mavericks
    sha256 "cde420aa902c9db464611078c8703999093d957cac95122e17daf404ebd063f7" => :mountain_lion
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
