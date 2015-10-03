class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.0.tar.xz"
  sha256 "1aeec77db6eb8087049af39a07f55756c55319f739d2998030fe6f4ced03ca76"

  bottle do
    sha256 "ead8cbf2ea672c497168af002f106a86b306b754740306644e91983f1ac7cc88" => :el_capitan
    sha256 "e6145aac15a1bd1881b4d086f2beb16381a08c22cf7607ba23adaa142e6b23b3" => :yosemite
    sha256 "f52c086290695db1f94d1b70c906eef92f54f615825ade5496efbea39ad55eaf" => :mavericks
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
