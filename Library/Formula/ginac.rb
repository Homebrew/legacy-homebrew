class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.4.tar.bz2"
  sha256 "6241158216b4f68c625ce7d843d5b6b070304f87e7fc8f4075b76501ca0f3c60"

  bottle do
    cellar :any
    sha256 "c10a38a7217934a63a76da2c29986c4093c3e5c0ff419cb8363f576c0aea5ef7" => :yosemite
    sha256 "526b8c7b60c708d6a8768c1fcc31b463ea86622af598d7aa2a76ba49185d4ff7" => :mavericks
    sha256 "fed7446f2fe22e0ac04796d363edb159f5882501b7c354efb08636d5e88f21af" => :mountain_lion
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
