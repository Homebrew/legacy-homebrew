class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.4.tar.bz2"
  sha256 "6241158216b4f68c625ce7d843d5b6b070304f87e7fc8f4075b76501ca0f3c60"

  bottle do
    cellar :any
    sha1 "04f032b8d9f13b33457cf78569b71a55572fb2b8" => :yosemite
    sha1 "ecc3f94892bccb66c9f240aecc9d6d70e8fbf500" => :mavericks
    sha1 "062569680b5a725eb0316574ba2d6c22760a02e2" => :mountain_lion
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
