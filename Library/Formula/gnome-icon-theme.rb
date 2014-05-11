require "formula"

class GnomeIconTheme < Formula
  homepage "https://developer.gnome.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/gnome-icon-theme/3.12/gnome-icon-theme-3.12.0.tar.xz"
  sha1 "cc0f0dc55db3c4ca7f2f34564402f712807f1342"

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "gtk+" => :build # for gtk-update-icon-cache
  depends_on "icon-naming-utils" => :build
  depends_on "intltool" => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
