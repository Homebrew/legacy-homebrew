require "formula"

class JsonGlib < Formula
  homepage "http://live.gnome.org/JsonGlib"
  url "http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.2.tar.xz"
  sha256 "887bd192da8f5edc53b490ec51bf3ffebd958a671f5963e4f3af32c22e35660a"

  bottle do
    revision 2
    sha1 "58daae021ca6c990a0e29e5b7c72699ca4e4800a" => :yosemite
    sha1 "18168428af31175e10e4c9f52809c58c6afebc22" => :mavericks
    sha1 "64de84e6abc6bcc2700e45d6288646d14bf5fc05" => :mountain_lion
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
