class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.14/at-spi2-core-2.14.1.tar.xz"
  sha256 "eef9660b14fdf0fb1f30d1be7c72d591fa7cbb87b00ca3a444425712f46ce657"

  bottle do
    sha1 "55a2b1ac3135f842dcc0b6a6549fd8759dba04d9" => :yosemite
    sha1 "b36adb7ba21229a29bd197a2c608590c3bd4fc40" => :mavericks
    sha1 "40096cac5242b87318ee81ccc07252e1a6a5331c" => :mountain_lion
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
    system "make", "install"
  end
end
