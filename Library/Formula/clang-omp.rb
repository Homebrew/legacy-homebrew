class ClangOmp < Formula
  homepage "https://clang-omp.github.io/"
  url "https://github.com/clang-omp/llvm/archive/2015-04-01.tar.gz"
  version "2015-04-01"
  sha256 "37f990ad99b3213507ec88f86702c5a057ce397cc16638eeee5c88906572daec"

  bottle do
    revision 1
    sha256 "dfc5f4c5ca5f91b71f6e6c71934371f823f3d9f922184954289c0fa58c610738" => :yosemite
    sha256 "0cf85df1cade74005852efe44292babf82582e46f105fd752699e3b6d7258ce5" => :mavericks
    sha256 "9bc657cd6162cfe4755733e22c2292748ec4073cc1372737c2e07094f10958b6" => :mountain_lion
  end

  depends_on "libiomp"
  depends_on "cmake" => :build

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

  needs :cxx11

  def install
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")
    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"projects/libcxx").install resource "libcxx"

    system "./configure", "--prefix=#{libexec}", "--enable-cxx11", "--enable-libcpp"
    system "make"
    system "make", "install"

    system "make", "-C", "projects/libcxx", "install",
      "DSTROOT=#{prefix}", "SYMROOT=#{buildpath}/projects/libcxx"

    bin.install_symlink libexec/"bin/clang" => "clang-omp"
    bin.install_symlink libexec/"bin/clang" => "clang-omp++"
  end

  test do
    testfile = <<-EOS.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <libiomp/omp.h>

      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS
    (testpath/"test.c").write(testfile)
    system "#{bin}/clang-omp", "-L/usr/local/lib", "-liomp5", "-fopenmp", "-Werror", "-Wall", "test.c", "-o", "test"
    system "./test>#{testpath}/testresult"

    testresult = (testpath/"testresult").read
    testresult_lines = testresult.split "\n"
    sorted_testresult_lines = testresult_lines.sort
    sorted_testresult = sorted_testresult_lines.join "\n"
    expected_result = <<-EOS.undent
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    assert_equal expected_result.strip, sorted_testresult.strip
  end
end
