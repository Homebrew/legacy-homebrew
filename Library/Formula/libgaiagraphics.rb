require "formula"

class Libgaiagraphics < Formula
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha1 "db9eaef329fc650da737c71aac6136088fcb6549"

  bottle do
    cellar :any
    revision 1
    sha1 "01d3f42ea440d68de828b842c5b8526f697a6b14" => :yosemite
    sha1 "0cc91a527557a222c03ead9c4393a1b5decd7821" => :mavericks
    sha1 "6d1fbadfa1580a1ae71ea22ea4ebbf215766ce6f" => :mountain_lion
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
