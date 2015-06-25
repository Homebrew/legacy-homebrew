class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "http://www.cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/db9052/pdf2svg/archive/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"

  bottle do
    cellar :any
    sha256 "786c55feabe3accf358cd8749e5579cabab96c8c33098ab8f4164227c864bd01" => :yosemite
    sha256 "7d4235fa396d76c58637be177306ab52ac8b97e2d8fd4010349f8f447117426e" => :mavericks
    sha256 "1a85e25f7769ec7a37357fb628953959e8a8216f875df894bc64bb400ed808a7" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2svg", test_fixtures("test.pdf"), "test.svg"
  end
end
