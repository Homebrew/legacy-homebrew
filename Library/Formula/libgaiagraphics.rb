require "formula"

class Libgaiagraphics < Formula
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha1 "db9eaef329fc650da737c71aac6136088fcb6549"

  bottle do
    cellar :any
    sha1 "2f529e4d286413b9fd423ef8ad10c6addfe6e278" => :mavericks
    sha1 "d2c56a59614c33dcbd6604363c78f008e43cf22c" => :mountain_lion
    sha1 "3cd754d017caf49793ae151a977101e87128e09a" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "jpeg"
  depends_on "cairo"
  depends_on "libpng"
  depends_on "proj"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
