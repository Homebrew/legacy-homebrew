class ClangOmp < Formula
  homepage "https://clang-omp.github.io/"
  url "https://github.com/clang-omp/llvm/archive/1013141148.tar.gz"
  sha256 "744e83339eca7494fe731c945fc12ab15a5e496de4b859f0d77301310c847a14"

  depends_on "libiomp"
  depends_on "cmake" => :build

  resource "compiler-rt" do
    url "https://github.com/clang-omp/compiler-rt/archive/1013141148.tar.gz"
    sha256 "ef289ca49c0282cb32053d56d319732ea1cce6b8fdd10814bcfbe4f8abd9bfea"
  end

  resource "clang" do
    url "https://github.com/clang-omp/clang/archive/1013141148.tar.gz"
    sha256 "a18fe403933f31471f11e6365c742a4f932dec42a55589c36b570c53cc21d358"
  end

  needs :cxx11

  def install
    resource("compiler-rt").stage { (buildpath/"projects/compiler-rt").install Dir["*"] }
    resource("clang").stage { (buildpath/"tools/clang").install Dir["*"] }

    system "./configure", "--prefix=#{prefix}", "--enable-cxx11", "--enable-libcpp"
    system "make", "install"

    mv bin/"clang", bin/"clang-omp"
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
