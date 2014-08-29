require "formula"

class JsonGlib < Formula
  homepage "http://live.gnome.org/JsonGlib"
  url "http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.2.tar.xz"
  sha256 "887bd192da8f5edc53b490ec51bf3ffebd958a671f5963e4f3af32c22e35660a"

  bottle do
    sha1 "663248e7dce058f796836a01b0b37d82b7d2c942" => :mavericks
    sha1 "b786fdf1a2c03efd5b67a34779e0e345224684a1" => :mountain_lion
    sha1 "4d01ece8773d3893db5f0f1b2c4c4618a3dbd4ae" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make install"
  end
end
