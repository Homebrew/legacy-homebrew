class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools."
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.10.tar.xz"
  sha256 "592c53289ff1cd70e676405c56ca87b28d2da37a385d34a3bb9b944ba9108d17"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "ossp-uuid"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
