class Libdecnumber < Formula
  desc "ANSI C implementation of General Decimal Arithmetic"
  homepage "http://speleotrove.com/decimal/#decNumber"
  url "http://download.icu-project.org/files/decNumber/decNumber-icu-368.zip"
  version "3.68"
  sha256 "14ec2cf30b58758493a7661b78b80abfb281652b61a425b85cda83173518fe25"
  resource "cmakelists" do
    url "https://raw.githubusercontent.com/alkis/decnumber-cmake/master/CMakeLists.txt"
    sha256 "eb8bb964b5382e5cc9ea6530585f2567b19ffc280d1b78ee2ebb8151c6cb9b9a"
  end

  depends_on "cmake" => :build

  def install
    resource("cmakelists").stage { mv("CMakeLists.txt", @buildpath) }
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "decQuad.h"
      #include <stdio.h>
      int main(int argc, char *argv[]) {
        decQuad a, b;
        decContext set;
        char string[DECQUAD_String];
        decContextTestEndian(0);
        decContextDefault(&set, DEC_INIT_DECQUAD);
        decQuadFromString(&a, "1.123", &set);
        decQuadFromString(&b, "3.321", &set);
        decQuadAdd(&a, &a, &b, &set);
        decQuadToString(&a, string);
        puts(string);
     }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldecnumber",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
