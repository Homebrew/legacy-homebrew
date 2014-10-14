require "formula"

class AtSpi2Core < Formula
  homepage "http://a11y.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/at-spi2-core/2.14/at-spi2-core-2.14.0.tar.xz"
  sha256 "5807b02e6ef695b52fde7ff26d675dd94a0707df3c42fe7fd224828e092514c8"

  bottle do
    sha1 "81d698ef6592a3dc2f1e34d2fc895d81cd79336b" => :mavericks
    sha1 "d5513c28dc9326b161840deeb0c148a2d1f3bcd3" => :mountain_lion
    sha1 "cd3260c7814275528333bfe4cf1e56a7d920cdf8" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "d-bus"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make install"
  end
end
