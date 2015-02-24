require "formula"

class Tinyxml2 < Formula
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/2.2.0.tar.gz"
  sha1 "7869aa08241ce16f93ba3732c1cde155b1f2b6a0"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha1 "1a5b0decafe9a001614724bfc10652901ef6689f" => :mavericks
    sha1 "9ee5af184fc7eff9938387d563de7b7d31c24632" => :mountain_lion
    sha1 "80d5625994120b1146376ef2978c416cd011e96c" => :lion
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
    system ENV.cc, "test.cpp", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
