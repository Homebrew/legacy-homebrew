class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "http://muparser.beltoforion.de/"
  url "https://github.com/beltoforion/muparser/archive/v2.2.5.tar.gz"
  sha256 "0666ef55da72c3e356ca85b6a0084d56b05dd740c3c21d26d372085aa2c6e708"

  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    sha256 "3d580042b67b5f23bb7c255baaf6c079e030516afc7f0bb25d3978259628f098" => :yosemite
    sha256 "6e4a1373a02ff289d474514fdffc77a80cebf30e37fb5fe51f2dd9c659163bf4" => :mavericks
    sha256 "b3ca223c600162789f56a26d73db8b086234a16923d0db6c346f2accef30d829" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

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
