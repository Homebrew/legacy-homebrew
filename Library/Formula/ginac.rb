class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.7.tar.bz2"
  sha256 "cea5971b552372017ea654c025adb44d5f1b3e3ce0a739da2fe95189572b85db"

  bottle do
    cellar :any
    sha256 "671d789e027d4975c547cf22f7dad5107b49cb13de42895382b57e6645fbb20b" => :el_capitan
    sha256 "42c5df72efb11bcd3bf32c1578527f2c21ed403f9c07b98bc0e9cfa8e8ca8c7c" => :yosemite
    sha256 "eee8d592da0e4aae053c4a6424b66a1a7d9f2e8351d2bb80d915bf5d0cb5bf7f" => :mavericks
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
