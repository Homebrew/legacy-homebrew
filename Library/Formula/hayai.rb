class Hayai < Formula
  desc "A C++ benchmarking framework inspired by the googletest framework"
  homepage "http://nickbruun.dk/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v0.1.0.tar.gz"
  sha256 "739d6dc5126a0b3dfe6c944999f48e7ede823bfdbf1f8801f23af25bf355db65"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <hayai/hayai.hpp>
      #include <iostream>
      int main() {
        hayai::Benchmarker::RunAllTests();
        return 0;
      }

      BENCHMARK(HomebrewTest, TestBenchmark, 1, 1)
      {
        std::cout << "Hayai works!" << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-lhayai_main", "-o", "test"
    system "./test"
  end
end
