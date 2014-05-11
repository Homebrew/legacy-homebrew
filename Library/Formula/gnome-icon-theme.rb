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

  bottle do
    cellar :any
    sha1 "d0540a403786f3b7a64e9d29f41fc1ea691179c5" => :mavericks
    sha1 "1ad3bcd28fa71c198154030bb1d8e8bff8d3f868" => :mountain_lion
    sha1 "43f0035b70fd722ffefb79b7356e0f34a5ba4abf" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
