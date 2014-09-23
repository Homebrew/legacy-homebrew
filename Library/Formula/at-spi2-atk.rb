require "formula"

class AtSpi2Atk < Formula
  homepage "http://a11y.org"
  url "http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.14/at-spi2-atk-2.14.0.tar.xz"
  sha256 "56b40ef16d9f1b1630d32addb0cc941372a1e97d8ddafd369f912c7d125688e7"

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
