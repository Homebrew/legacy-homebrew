require "formula"

class AtSpi2Core < Formula
  homepage "http://a11y.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/at-spi2-core/2.14/at-spi2-core-2.14.1.tar.xz"
  sha256 "eef9660b14fdf0fb1f30d1be7c72d591fa7cbb87b00ca3a444425712f46ce657"

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "d-bus"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make install"
  end
end
