require "formula"

class Tinyxml2 < Formula
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/2.1.0.tar.gz"
  sha1 "70ef3221bdc190fd8fc50cdd4a6ef440f44b74dc"
  head "https://github.com/leethomason/tinyxml2.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "82860d4195cb6c1230770cb35899a26480d608b3" => :mavericks
    sha1 "bebfd80f824aeccc679c3efd719457f353d8132e" => :mountain_lion
    sha1 "4fba761a6b118583a2ef064c43b7a839fe210cd3" => :lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-ltinyxml2"
  end
end
