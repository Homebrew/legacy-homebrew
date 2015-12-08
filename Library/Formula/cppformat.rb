class Cppformat < Formula
  desc "Open-source formatting library for C++"
  homepage "https://cppformat.github.io/"
  url "https://github.com/cppformat/cppformat/releases/download/2.0.0/cppformat-2.0.0.zip"
  sha256 "0f6f680fb1e5b192ed1820dca9d2f1171a0ad1d91b5a935ac5c25899e6861f0e"

  bottle do
    cellar :any
    sha256 "69209bdc16296c7d84ca4e1484f64384c7e880715d338be69e792fe3e55976d6" => :yosemite
    sha256 "caef34333b39765174c968ff3a7bbdf303894a9a402b172b4035338b7ca88c0c" => :mavericks
    sha256 "b2880f33158da37e8a1b064e2bd30edb6c091cff42b6c126fb1b0627f682850f" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <string>
      #include <cppformat/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lcppformat"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
