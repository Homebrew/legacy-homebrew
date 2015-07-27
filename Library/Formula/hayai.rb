class Hayai < Formula
  desc "A C++ benchmarking framework inspired by the googletest framework"
  homepage "http://nickbruun.dk/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v1.0.1.tar.gz"
  sha256 "40798cb3a7b5fcd4e0be65f9358dad4efeef7c4ebe8319327d99a2b8e5dcea4c"

  bottle do
    sha256 "3bc74df44803916f35cba264b4785d3b370ead8fc8dcce37493140504f562a3f" => :yosemite
    sha256 "31adaeee9eb993ad1eee8285ae3841cb26c5fded54368899ed6578d3e70664ed" => :mavericks
    sha256 "717b2a63a7c070498351a24f8e41c40ea982d21ef32b6c074a442e3714974597" => :mountain_lion
  end

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
