require "formula"

class GupnpTools < Formula
  homepage "https://wiki.gnome.org/GUPnP/"
  url "http://ftp.gnome.org/pub/gnome/sources/gupnp-tools/0.8/gupnp-tools-0.8.9.tar.xz"
  sha1 "afe0855510740bf44bc32b716bd0687edcda0f94"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gnome-icon-theme"
  depends_on "gtk+3"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "ossp-uuid"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
