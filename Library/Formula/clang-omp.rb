class ClangOmp < Formula
  homepage "https://clang-omp.github.io/"
  url "https://github.com/clang-omp/llvm/archive/2015-04-01.tar.gz"
  version "2015-04-01"
  sha256 "37f990ad99b3213507ec88f86702c5a057ce397cc16638eeee5c88906572daec"

  bottle do
    sha256 "ed23f2f98cd280c73f53c31a281a3baee6a7e89cdd2f6f1388502fae6ea043fe" => :yosemite
    sha256 "de14d6887271d0926d0ef4b3eb5f74366955d92d7de231a9ba8c71ce6f8443d1" => :mavericks
    sha256 "7d58ef5113604b044c916dcb1920157d77247eb60e0c508a67d285e139b576e0" => :mountain_lion
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

  needs :cxx11

  def install
    resource("compiler-rt").stage { (buildpath/"projects/compiler-rt").install Dir["*"] }
    resource("clang").stage { (buildpath/"tools/clang").install Dir["*"] }

    system "./configure", "--prefix=#{libexec}", "--enable-cxx11", "--enable-libcpp"
    system "make", "install"

    bin.install_symlink libexec/"bin/clang" => "clang-omp"
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
