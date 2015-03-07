require "formula"

class Atk < Formula
  homepage "http://library.gnome.org/devel/atk/"
  url "http://ftp.gnome.org/pub/gnome/sources/atk/2.14/atk-2.14.0.tar.xz"
  sha256 "2875cc0b32bfb173c066c22a337f79793e0c99d2cc5e81c4dac0d5a523b8fbad"

  bottle do
    revision 1
    sha1 "5a014bce43ff14675bec23b61909d3d85cff20f1" => :yosemite
    sha1 "f75b7b55547cb58c87fd35e38e8cdba0877516f8" => :mavericks
    sha1 "8aa05a84f58854ba26258d0d206c4e2fb663eb16" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make install"
  end
end
