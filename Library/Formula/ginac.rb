class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.5.tar.bz2"
  sha256 "e8630e186d9846123c58de7e0edcfd11b68d3831a84ae7c039c0606397b01444"

  bottle do
    cellar :any
    sha256 "8d03b4cdd2c00bca33628f222c7cc2f4372801d6c1c58dbad4e70812aa68cd0c" => :el_capitan
    sha256 "f42fd7ea1d746ef9ef48d5de0288f87a2f2e31440465cbf109fd1d47e86938f4" => :yosemite
    sha256 "fae7e831441f104ec797ef21c861d4d87e49fb2c85c8dcd7699e42d38d6a7003" => :mavericks
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
