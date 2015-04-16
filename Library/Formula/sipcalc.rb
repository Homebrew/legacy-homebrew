class Sipcalc < Formula
  homepage "http://www.routemeister.net/projects/sipcalc/"
  url "http://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.6.tar.gz"
  sha256 "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipcalc", "-h"
  end
end
