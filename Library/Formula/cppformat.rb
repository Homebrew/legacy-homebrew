class Cppformat < Formula
  homepage "https://cppformat.github.io/"
  url "https://github.com/cppformat/cppformat/releases/download/1.1.0/cppformat-1.1.0.zip"
  sha256 "bfa5db9d5bafe079b711981c336ec33b3980715aadf89efc7855aca507845a0e"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <string>
      #include <format.h>
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
                  "-lformat"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
