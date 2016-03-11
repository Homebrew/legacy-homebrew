class GoogleBenchmark < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/v0.1.0.tar.gz"
  sha256 "41aa7dca7aa94911deee078e39f7602d760f2911bb33086b5a2c8204717ddad4"
  head "https://github.com/google/benchmark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1089613070009bfe94e4ae876fc207b27cafaf1ce69b0543a79476d8de59eba3" => :el_capitan
    sha256 "b0aef4edb826741cc345ab10ba7cc171f8e43500e6002c68652553b59a7b36de" => :yosemite
    sha256 "e92b46b0076f5b770a05815de28dbad066a95213be8d484a7a8f6e8f02efd840" => :mavericks
    sha256 "0bf91d493e9f78a949c6794276be0365cd9e8436d8e8d84ed4083b2fb6256700" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-stdlib=libc++", "-I#{include}", "-L#{lib}", "-lbenchmark"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
