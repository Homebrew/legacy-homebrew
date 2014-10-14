require "formula"

class Atk < Formula
  homepage "http://library.gnome.org/devel/atk/"
  url "http://ftp.gnome.org/pub/gnome/sources/atk/2.14/atk-2.14.0.tar.xz"
  sha256 "2875cc0b32bfb173c066c22a337f79793e0c99d2cc5e81c4dac0d5a523b8fbad"

  bottle do
    sha1 "b2ca7320d38039694c3258b9d11acaf47f5a3753" => :mavericks
    sha1 "c04320419d8bac71188e0f01d7a5914fce0cf296" => :mountain_lion
    sha1 "913adb577075b21f48f23770361f005f21259b57" => :lion
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
