require "formula"

class Gupnp < Formula
  homepage "https://wiki.gnome.org/GUPnP/"
  url "http://ftp.gnome.org/pub/gnome/sources/gupnp/0.20/gupnp-0.20.12.tar.xz"
  sha1 "fbc23c0fa0df70f44d50b2ed88dc2c4dc06d166c"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
