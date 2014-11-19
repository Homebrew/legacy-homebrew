require "formula"

class Gtksourceview3 < Formula
  homepage "http://projects.gnome.org/gtksourceview/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.14/gtksourceview-3.14.2.tar.xz"
  sha256 "b3c4a4f464fdb23ecc708a61c398aa3003e05adcd7d7223d48d9c04fe87524ad"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
