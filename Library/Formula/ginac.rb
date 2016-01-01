class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.6.tar.bz2"
  sha256 "25ec6d535ee77caf6161843688489cfc319b6c4fda46c5d7878587ee5562ddce"

  bottle do
    cellar :any
    sha256 "45124b5232ab0557d7f6c3ef9c0db6a89e794d483a8c0f359d0650ffd8f04e02" => :el_capitan
    sha256 "fd6b1dc818a00d67f422c09e25456aa3c94196d4d625938ffe46346b61115a3d" => :yosemite
    sha256 "10bad801ed6186c7e1455bbe7783da73cf725089f63bf830543e6e9d5ebc8b35" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <iostream>
    #include <ginac/ginac.h>
    using namespace std;
    using namespace GiNaC;

    int main() {
      symbol x("x"), y("y");
      ex poly;

      for (int i=0; i<3; ++i) {
        poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
      }

      cout << poly << endl;
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test"
    system "./test"
  end
end
