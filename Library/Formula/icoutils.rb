class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.31.0.tar.bz2"
  sha256 "a895d9d74a418d65d39a667e58ae38be79c9e726711384551d36531696f3af71"
  revision 1

  bottle do
    cellar :any
    revision 3
    sha256 "5ca4983a1d452b8bfa69a993aa4bc32a7c380ed77bf0eebc8ec0467f4bd0166d" => :el_capitan
    sha256 "8ae9286753630fc4651e7e717a286ada24e9dd542e70e51b83e47b86d58725ab" => :yosemite
    sha256 "6e587cd1183704f788d7d2e0165f573ec3ce16828c7fd3bf82d06ece3dd2b3e1" => :mavericks
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/icotool", "-l", test_fixtures("test.ico")
  end
end
