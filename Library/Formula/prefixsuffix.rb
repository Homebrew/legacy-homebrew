class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.6.tar.xz"
  sha256 "2d6b9d9b4b0f0699828d1aa0799d30cd173274fde57d063089e519ea794ca9a0"

  bottle do
    sha256 "f7f00db2e39546fdc85ae153223d861703a6200736c4176f0d026adcfeab79a7" => :el_capitan
    sha256 "54123b148ef7f22c64e8ad70d274e098ff6e1af73dbd8e092a2c86da46be28f1" => :yosemite
    sha256 "45e8bc8da91cefebc45846c14bec29dcd21f8fd93702b43d0f663754ebd13542" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtkmm3"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/prefixsuffix", "--version"
  end
end
