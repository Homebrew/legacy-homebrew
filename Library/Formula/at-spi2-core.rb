class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.0.tar.xz"
  sha256 "1aeec77db6eb8087049af39a07f55756c55319f739d2998030fe6f4ced03ca76"

  bottle do
    sha256 "b15229c8b3d6d349c44038d0da14817f96bbbc68e8b263c986891ca75bd575fd" => :el_capitan
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
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
