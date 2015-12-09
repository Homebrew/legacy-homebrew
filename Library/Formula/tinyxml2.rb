class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/3.0.0.tar.gz"
  sha256 "128aa1553e88403833e0cccf1b651f45ce87bc207871f53fdcc8e7f9ec795747"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "4853a6b2bb984f58e10cc3b45a3102cec30bb93c43d752b85c43f6c4ad4a729c" => :el_capitan
    sha256 "b79adb5c96cd74936064056b697a241e5fe2d2adc82a67b7bff65d36221e9aec" => :yosemite
    sha256 "2ff2104bbdee6870a91603ca22848095a21f939a0d0fc9454bc2a0a553b3c498" => :mavericks
    sha256 "4181968c3b03f0bfb7fe9ae4fe044b4a8c9bafb32b9b5730a57da3e5592d3ed9" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
