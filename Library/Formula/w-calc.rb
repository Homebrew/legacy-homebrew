class WCalc < Formula
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
  bottle do
    cellar :any
    sha1 "dcd1bc693b7536d7f7707e82de4214a7327d9af3" => :yosemite
    sha1 "53a6091c244cc590eba9d8f68e12d0821fbd604b" => :mavericks
    sha1 "b8494cd0a26356c9a0f4307057978cd231499541" => :mountain_lion
  end

  desc "Very capable calculator"
  homepage "http://w-calc.sourceforge.net"
  sha256 "0e2c17c20f935328dcdc6cb4c06250a6732f9ee78adf7a55c01133960d6d28ee"

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wcalc", "2+2"
  end
end
