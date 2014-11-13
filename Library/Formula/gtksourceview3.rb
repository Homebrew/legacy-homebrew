require "formula"

class Gtksourceview3 < Formula
  homepage "http://projects.gnome.org/gtksourceview/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.14/gtksourceview-3.14.0.tar.xz"
  sha256 "b6a6036af0209cbc591afbae2fb13d2a92898a52cb76f652b94034da1bc0eba4"

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
