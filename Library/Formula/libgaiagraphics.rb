class Libgaiagraphics < Formula
  desc "Library supporting common-utility raster handling"
  homepage "https://www.gaia-gis.it/fossil/libgaiagraphics/index"
  url "http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz"
  sha1 "db9eaef329fc650da737c71aac6136088fcb6549"
  revision 1

  bottle do
    cellar :any
    sha256 "bf888c8840d68b96d7c1b50222d0bf042768373aeecfacbe210bcf84dd7afa63" => :yosemite
    sha256 "bdd0a108eafc3642846f8e787129f8fea587000fd586c5caa4da61318e55d7aa" => :mavericks
    sha256 "04b0752f86b0f96503e266bdc64f66fc5aaabcd7d79400f1f88a9c71b811d78e" => :mountain_lion
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
