require "formula"

class Libgee < Formula
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgee/0.14/libgee-0.14.0.tar.xz"
  sha1 "ca6531c8ba45cc865f2ce7b93a8b3f96e1c1505e"

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gobject-introspection"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-introspection=yes"
    system "make install"
  end
end
