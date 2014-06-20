require 'formula'

class WCalc < Formula
  url 'https://downloads.sourceforge.net/w-calc/wcalc-2.4.1.tar.bz2'
  homepage 'http://w-calc.sourceforge.net'
  sha1 'e3ba04dcfc60a47b60c79fc6f9f4a8fa750ee5f9'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wcalc 2+2"
  end

end
