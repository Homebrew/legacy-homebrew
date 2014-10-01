require "formula"

class AtSpi2Atk < Formula
  homepage "http://a11y.org"
  url "http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.14/at-spi2-atk-2.14.0.tar.xz"
  sha256 "56b40ef16d9f1b1630d32addb0cc941372a1e97d8ddafd369f912c7d125688e7"

  bottle do
    cellar :any
    sha1 "f11701fff9c808d0be86ab0245b7b166e95cf371" => :mavericks
    sha1 "a2cb17226b9d03779b67f52c42c5668ff3d4e6b2" => :mountain_lion
    sha1 "690f4136be39fb82537dab0dcb090c87ddd7177d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
