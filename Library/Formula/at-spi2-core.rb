class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.1.tar.xz"
  sha256 "57d555be4cc64905454687bf9bb7dc1e68531bee93befa77222d94ea083f01cf"

  bottle do
    sha256 "e0a6e1d32e84d0736c7f2a24051aaf5b0b97215b5ab2d86858a994b23a2fc77d" => :el_capitan
    sha256 "009015fa1d63d0c60f6d3006435affd691f24b223d3525f06cc612dad0ac5e38" => :yosemite
    sha256 "9e31b1f399ddd15de1822b6e8cb3637bab6346633efd25dea21b5b19aeee69ff" => :mavericks
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
