require "formula"

class Atk < Formula
  homepage "http://library.gnome.org/devel/atk/"
  url "http://ftp.gnome.org/pub/gnome/sources/atk/2.14/atk-2.14.0.tar.xz"
  sha256 "2875cc0b32bfb173c066c22a337f79793e0c99d2cc5e81c4dac0d5a523b8fbad"

  bottle do
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
