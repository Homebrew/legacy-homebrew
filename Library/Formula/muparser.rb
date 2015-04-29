class Muparser < Formula
  homepage "http://muparser.beltoforion.de/"
  url "https://docs.google.com/uc?export=download&id=0BzuB-ydOOoduejdwdTQwcF9JLTA"
  version "2.2.4"
  sha256 "fe4e207b9b5ee0e8ba155c3a7cc22ea6085313e0a17b7568a8a86eaa0d441431"

  head "http://muparser.googlecode.com/svn/trunk/"

  bottle do
    cellar :any
    revision 1
    sha1 "138dd0da70ef47470e5f19b0261dc357d1734afd" => :mavericks
    sha1 "dcec9427dff9d1021281ebf0eb8ca22c3877e355" => :mountain_lion
    sha1 "95b0c1e1b228216c712f78892488db996d11ed30" => :lion
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
