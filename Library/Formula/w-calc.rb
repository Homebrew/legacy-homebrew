class WCalc < Formula
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
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
