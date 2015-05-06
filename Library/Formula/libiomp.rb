class Libiomp < Formula
  homepage "https://www.openmprtl.org/download"
  url "https://www.openmprtl.org/sites/default/files/libomp_20150227_oss.tgz"
  sha256 "a1d30fad0160400db325d270b632961d086026d2944520d67c6afc0e69ac93bf"

  depends_on :arch => :intel
  depends_on "cmake" => :build

  bottle do
    cellar :any
    sha256 "0b1100fbe25cdf739f60d85988c0f7f73d33a4a1e97de2b21e7f53258fd43a93" => :yosemite
    sha256 "311132571f71ac5d06665cab765a683bba53c53438d07a59f1a143d8db211787" => :mavericks
    sha256 "b26fa4413afcd9ae18743efd462d1d7e8541fe41fa52e4a864dbd845db5cbe42" => :mountain_lion
  end

  fails_with :gcc  do
    cause "libiomp can only be built with clang."
  end

  fails_with :gcc_4_0 do
    cause "libiomp can only be built with clang."
  end

  ("4.3".."4.9").each do |n|
    fails_with :gcc => n do
      cause "libiomp can only be built with clang."
    end
  end

  def install
    intel_arch = MacOS.prefer_64_bit? ? "mac_32e" : "mac_32"
    args = std_cmake_args
    args << (MacOS.prefer_64_bit? ? "-Darch=32e" : "-Darch=32")
    args << "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", ".", *args
    system "make", "all", "common"

    (include/"libiomp").install Dir["exports/common/include/*"]
    lib.install "exports/#{intel_arch}/lib.thin/libiomp5.dylib"
  end

  test do
    testfile = <<-EOS.undent
      #include <omp.h>
      #include <stdlib.h>

      int main(void) {
          omp_set_num_threads(2);
          omp_get_num_threads();
          return EXIT_SUCCESS;
      }
    EOS
    (testpath/"test.c").write(testfile)
    system ENV.cc, "-L#{lib}", "-liomp5", "-I#{include}/libiomp", "test.c", "-o", "test"
    system "./test"
  end
end
