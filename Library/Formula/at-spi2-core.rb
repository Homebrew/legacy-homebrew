class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.3.tar.xz"
  sha256 "ada26add94155f97d0f601a20cb7a0e3fd3ba1588c3520b7288316494027d629"

  bottle do
    sha256 "96b67926248f6950a20ea28fde034e9a91b6c4c4a14eb3cd54e0aead53224ce6" => :el_capitan
    sha256 "2c413dbe96a387b290cdc2d9079f6c54be5f4409d3e5785779d5b7f3681bebd9" => :yosemite
    sha256 "310fe864ee0b4e81fd58e901b02cc9cb16cd8ae21e4cb2438d6e2ff764986d04" => :mavericks
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
