class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "http://savannah.nongnu.org/download/icoutils/icoutils-0.31.0.tar.bz2"
  sha256 "a895d9d74a418d65d39a667e58ae38be79c9e726711384551d36531696f3af71"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "1315328cc26b6b451988ec90e90e1275248e77fb7b1832f6b0bebd9576e12f8c" => :yosemite
    sha256 "9fbee2309af99b4227774615f27f5907d66c139592c9b743a4836002e7a56591" => :mavericks
    sha256 "11a997405f353431ff5dac5050c2668fdf3241b9e124ca38408a2a05a8b10b09" => :mountain_lion
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
