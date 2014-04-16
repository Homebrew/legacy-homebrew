require "formula"

class Tinyxml2 < Formula
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/2.0.2.tar.gz"
  sha1 "c78a4de58540e2a35f4775fd3e577299ebd15117"
  head "https://github.com/leethomason/tinyxml2.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "21ac26ad280788da33d3d40b85c51443b8e621bb" => :mavericks
    sha1 "796b13f7e196897af63cd41e149bea133774a61f" => :mountain_lion
    sha1 "623579a7a5216e1789f2ef97c6048ccbf349f99b" => :lion
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
