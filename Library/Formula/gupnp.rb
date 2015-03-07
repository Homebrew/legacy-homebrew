require "formula"

class Gupnp < Formula
  homepage "https://wiki.gnome.org/GUPnP/"
  url "http://ftp.gnome.org/pub/gnome/sources/gupnp/0.20/gupnp-0.20.12.tar.xz"
  sha1 "fbc23c0fa0df70f44d50b2ed88dc2c4dc06d166c"

  bottle do
    cellar :any
    sha1 "7e087d225faef24ee34409c6270f6fb61d0a4363" => :yosemite
    sha1 "b655501ca5f652c9c50cefc5de947879bea10ea8" => :mavericks
    sha1 "32aa5ac058cfa42c20dbdc3f92684cd6ce57a9d4" => :mountain_lion
  end

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
