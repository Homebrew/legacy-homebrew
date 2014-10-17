require "formula"

class ClangOmp < Formula
  homepage "http://clang-omp.github.io/"
  url "https://github.com/clang-omp/llvm/archive/1013141148.tar.gz"
  sha1 "84b67237aa3a5603143eb22e967b8b35f127bc4e"

  depends_on "cmake" => :build

  resource "compiler-rt" do
    url "https://github.com/clang-omp/compiler-rt/archive/1013141148.tar.gz"
    sha1 "e85548d5b7d0f99d9699af7d17f2dbac1674b19d"
  end

  resource "clang" do
    url "https://github.com/clang-omp/clang/archive/1013141148.tar.gz"
    sha1 "e066330a9fc699b9c539eeab4090c998b3f78214"
  end

  def install
    resource("compiler-rt").stage { (buildpath/'projects/compiler-rt').install Dir['*'] }
    resource("clang").stage { (buildpath/'tools/clang').install Dir['*'] }

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    mv bin/"clang", bin/"clang-omp"
  end

  test do
    testfile = <<-EOS.undent
      #include <stdlib.h>
      #include <stdio.h>

      int main(void) {
          #pragma omp parallel
          {
            printf("hello world");
          }
          return EXIT_SUCCESS;
      }
    EOS
    (testpath/"test.c").write(testfile)
    system "#{bin}/clang-omp", "-fopenmp", "-Werror", "-Wall", "test.c", "-o", "test"
    system "./test"
  end

end
