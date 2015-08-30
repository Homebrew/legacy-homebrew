class Libiomp < Formula
  desc "Manage multiple threads in an OpenMP program as it executes"
  homepage "https://www.openmprtl.org/download"
  url "https://www.openmprtl.org/sites/default/files/libomp_20150701_oss.tgz"
  sha256 "d0c1fcb5997c53e0c9ff4eec1de3392a21308731c06e6663f9d32ceb15f14e88"

  depends_on :arch => :intel
  depends_on "cmake" => :build

  bottle do
    cellar :any
    sha256 "b330ef085dbff40bdf5b3bf67beb8efd0573c67d5abe9c193f34f8cba1ba7e2c" => :yosemite
    sha256 "bc754820685040c0567edf3d7aeef1d5c1a25f532409b43673371854e16caca7" => :mavericks
    sha256 "231ec294a8d99a93a2336d06e2ebf5a1550f76f08ef168fa26c54dc15e0482bf" => :mountain_lion
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
    args << (MacOS.prefer_64_bit? ? "-DLIBOMP_ARCH=32e" : "-DLIBOMP_ARCH=32")
    system "cmake", ".", *args
    system "make", "all"

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
