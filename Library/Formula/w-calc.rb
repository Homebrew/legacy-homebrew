class WCalc < Formula
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
  bottle do
    cellar :any
    sha256 "1737fad1cd9e5beac6f3a06057bd594b4de2c6b9f709544acd4825fae9160632" => :yosemite
    sha256 "14bcdc8bb396d6c3890a7a7719d6619911ffe92e8949278865b256eb5f74682e" => :mavericks
    sha256 "0eb8fb2e15ee8274ec673850eb5004654e3f7c3d3a835597b5809e87420db08f" => :mountain_lion
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
