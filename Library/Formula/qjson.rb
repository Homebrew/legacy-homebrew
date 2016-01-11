class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "http://qjson.sourceforge.net"
  url "https://downloads.sourceforge.net/project/qjson/qjson/0.8.1/qjson-0.8.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/q/qjson/qjson_0.8.1.orig.tar.bz2"
  sha256 "cd4db5b956247c4991a9c3e95512da257cd2a6bd011357e363d02300afc814d9"
  head "https://github.com/flavio/qjson.git"

  bottle do
    revision 1
    sha256 "17cfd3051322f724d3796b104bf14a47d54e81f0421462619d8462e5b848d297" => :yosemite
    sha256 "0b4e1a589d1d479724f05e22afdfcb5aede88ec01aae7917956171b799772abc" => :mavericks
    sha256 "86d22c75328ecce5a07483b20ea2d9470c37a7f40184471d262a233e89e8cbdf" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <qjson/parser.h>
      int main() {
        QJson::Parser parser;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lqjson",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
