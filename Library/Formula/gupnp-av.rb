require "formula"

class GupnpAv < Formula
  homepage "https://wiki.gnome.org/GUPnP/"
  url "http://ftp.gnome.org/pub/gnome/sources/gupnp-av/0.12/gupnp-av-0.12.6.tar.xz"
  sha1 "8ea44b3b9bd1dcb2ad56d56943fc1cd235570d00"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
