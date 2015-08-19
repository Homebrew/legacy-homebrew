class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "http://muparser.beltoforion.de/"
  url "https://docs.google.com/uc?export=download&id=0BzuB-ydOOoduejdwdTQwcF9JLTA"
  version "2.2.4"
  sha256 "fe4e207b9b5ee0e8ba155c3a7cc22ea6085313e0a17b7568a8a86eaa0d441431"

  head "http://muparser.googlecode.com/svn/trunk/"

  bottle do
    cellar :any
    sha256 "3d580042b67b5f23bb7c255baaf6c079e030516afc7f0bb25d3978259628f098" => :yosemite
    sha256 "6e4a1373a02ff289d474514fdffc77a80cebf30e37fb5fe51f2dd9c659163bf4" => :mavericks
    sha256 "b3ca223c600162789f56a26d73db8b086234a16923d0db6c346f2accef30d829" => :mountain_lion
  end

  def install
    chmod 0755, "./configure"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include "muParser.h"

      double MySqr(double a_fVal)
      {
        return a_fVal*a_fVal;
      }

      int main(int argc, char* argv[])
      {
        using namespace mu;
        try
        {
          double fVal = 1;
          Parser p;
          p.DefineVar("a", &fVal);
          p.DefineFun("MySqr", MySqr);
          p.SetExpr("MySqr(a)*_pi+min(10,a)");

          for (std::size_t a=0; a<100; ++a)
          {
            fVal = a;  // Change value of variable a
            std::cout << p.Eval() << std::endl;
          }
        }
        catch (Parser::exception_type &e)
        {
          std::cout << e.GetMsg() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lmuparser",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
