class Icoutils < Formula
  homepage "http://www.nongnu.org/icoutils/"
  url "http://savannah.nongnu.org/download/icoutils/icoutils-0.31.0.tar.bz2"
  sha1 "2712acd33c611588793562310077efd2ff35dca5"
  revision 1

  bottle do
    cellar :any
    sha1 "5ec5b20bd4fed5a41fd533b025964b57324b443e" => :yosemite
    sha1 "2422f5637c3e21107994cb048109c4d1a8088ba2" => :mavericks
    sha1 "6e73b832e583c457d3106a3f1349e2dd0a71b46b" => :mountain_lion
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
