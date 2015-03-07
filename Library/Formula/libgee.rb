require "formula"

class Libgee < Formula
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgee/0.16/libgee-0.16.0.tar.xz"
  sha1 "d67e718138fb5788d6a1aea7f344e670adb77375"

  bottle do
    cellar :any
    revision 1
    sha1 "d09eb775cbac0b46eb75e548f52026a1395162b7" => :yosemite
    sha1 "ac4c971d1f2cb3e72f4670dd87e30447aaf11533" => :mavericks
    sha1 "efd2606ad62ff3368e6a72fb1df087a2085ee143" => :mountain_lion
  end

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
