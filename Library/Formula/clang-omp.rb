class ClangOmp < Formula
  desc "OpenMP C/C++ language extensions in Clang/LLVM compiler"
  homepage "https://clang-omp.github.io/"

  stable do
    url "https://github.com/clang-omp/llvm/archive/2015-04-01.tar.gz"
    version "2015-04-01"
    sha256 "37f990ad99b3213507ec88f86702c5a057ce397cc16638eeee5c88906572daec"

    resource "compiler-rt" do
      url "https://github.com/clang-omp/compiler-rt/archive/2015-04-01.tar.gz"
      sha256 "5a8d39ff6ce524e23fae32870f85b18d43f2795da2011d3cbb6b29d471bb27b7"
    end

    resource "clang" do
      url "https://github.com/clang-omp/clang/archive/2015-04-01.tar.gz"
      sha256 "2717115e5ba491e3b8119311f0d792420ba41be34a89733b9880eb3d3c09fbe5"
    end

    resource "libcxx" do
      url "https://github.com/llvm-mirror/libcxx/archive/release_35.tar.gz"
      sha256 "df23b356ae1953de671d1dc9093568330e074bbe48cd6d93d16173a793550c71"
    end
  end

  head do
    url "https://github.com/clang-omp/llvm_trunk.git"

    resource "compiler-rt" do
      url "https://github.com/clang-omp/compiler-rt_trunk.git"
    end

    resource "clang" do
      url "https://github.com/clang-omp/clang_trunk.git"
    end

    resource "libcxx" do
      url "https://github.com/llvm-mirror/libcxx.git"
    end
  end

  bottle do
    revision 2
    sha256 "9db72fb0f069d564f9ad509922ebabda30008587924b4af33b8b80c5795e7fdd" => :el_capitan
    sha256 "2d29cc7bcde757610a325e57c0ea0162cee97c2cf04ea424f8e4010c57ae2295" => :yosemite
    sha256 "3989eb56c26ca2903ea1bde7aaf0b02c05a5dbfc1eae59056860abca9c6d5fec" => :mavericks
    sha256 "2a848d5efa46b5cc6e906f2c71608c8098238a397e6979912dcef2b5b1d2807c" => :mountain_lion
  end

  depends_on "libiomp"
  depends_on "cmake" => :build

  needs :cxx11

  def install
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")
    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"projects/libcxx").install resource "libcxx"

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DC_INCLUDE_DIRS=#{Formula["libiomp"].opt_include}/libiomp:#{libexec}/include/c++/v1:#{libexec}/usr/include:/usr/include
      -DLLVM_ENABLE_LIBCXX=ON
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CXX_FLAGS=-mmacosx-version-min=#{MacOS.version}
    ]

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

    system "make", "-C", "#{buildpath}/projects/libcxx", "install",
      "DSTROOT=#{libexec}", "SYMROOT=#{buildpath}/projects/libcxx",
      "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    bin.install_symlink libexec/"bin/clang" => "clang-omp"
    bin.install_symlink libexec/"bin/clang" => "clang-omp++"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>

      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    system "#{bin}/clang-omp", "-liomp5", "-fopenmp", "test.c", "-o", "test"
    testresult = shell_output("./test")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<-EOS.undent
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    assert_equal expected_result.strip, sorted_testresult.strip
  end
end
