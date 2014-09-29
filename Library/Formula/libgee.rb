require "formula"

class Libgee < Formula
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgee/0.16/libgee-0.16.0.tar.xz"
  sha1 "d67e718138fb5788d6a1aea7f344e670adb77375"

  bottle do
    cellar :any
    sha1 "b2aa5f6b7389323b9f040f3260732a93f2a41dbe" => :mavericks
    sha1 "5e6fe305c3e56532c3c7e32cc6f41c9612263672" => :mountain_lion
    sha1 "f5254c7996bd9546b209d8e73acd8e8de069104f" => :lion
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
