class Hayai < Formula
  desc "C++ benchmarking framework inspired by the googletest framework"
  homepage "http://nickbruun.dk/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v1.0.1.tar.gz"
  sha256 "40798cb3a7b5fcd4e0be65f9358dad4efeef7c4ebe8319327d99a2b8e5dcea4c"

  bottle do
    cellar :any
    sha256 "cbbb73a1219f53aab9ab1d13c18f6916d2e48404533100803deab22aee94ce6d" => :yosemite
    sha256 "97bb918ab865fc2d6e1b49ddaa395d37c2c530b9665c9027aebcfe7752449078" => :mavericks
    sha256 "c4a5a5879b6d5482f19d6acec3fe38c1c7fbc8b33a212ad76a0c7fd9de35dd87" => :mountain_lion
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
