require "formula"

class Gtksourceview3 < Formula
  homepage "http://projects.gnome.org/gtksourceview/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.12/gtksourceview-3.12.3.tar.xz"
  sha256 "f31959a21a93a929ff15192287096e65479e082cfac48ea8566aae9f6ce2f5f7"

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
