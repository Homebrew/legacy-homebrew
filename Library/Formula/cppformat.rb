class Cppformat < Formula
  desc "Open-source formatting library for C++"
  homepage "https://cppformat.github.io/"
  url "https://github.com/cppformat/cppformat/releases/download/2.0.0/cppformat-2.0.0.zip"
  sha256 "0f6f680fb1e5b192ed1820dca9d2f1171a0ad1d91b5a935ac5c25899e6861f0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "384474bcf1de6c5e65781bbb89702edfbc26d1196ded1da685c0579d4f466607" => :el_capitan
    sha256 "5d122ca83c6d62238bb4fb87f59a5dd0d7ab8c90d662c81abec154c8909e0de7" => :yosemite
    sha256 "b6ef2a5513df531439f0f34b9687139a73f114c883ec57ba41fecf1abd46e60f" => :mavericks
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
