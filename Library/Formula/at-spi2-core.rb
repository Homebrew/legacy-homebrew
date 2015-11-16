class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.2.tar.xz"
  sha256 "4eea5ba07912ad955157761c4c9fdb6e3fab6ea91899a4db785eb47ae61f1ee5"

  bottle do
    sha256 "d31b8efc3b5410f2d900bc8f1e58fb3818989bff3da3bf8ec74e0ad130314153" => :el_capitan
    sha256 "6bbab5ca4b868057db64dc62e5fdb2299b2473781e5bfffe6768b88a4b22dd92" => :yosemite
    sha256 "8a4ec3621c4a0c9a331790a6dce8f2f807f88c28550bb3768f81c0530a0516a7" => :mavericks
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
