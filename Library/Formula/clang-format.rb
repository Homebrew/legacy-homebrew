class ClangFormat < Formula
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2014-12-03"

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/testing/2014-12-03/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/testing/2014-12-03/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.5.0/libcxx-3.5.0.src.tar.xz"
      sha1 "c98beed86ae1adf9ab7132aeae8fd3b0893ea995"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  fails_with :clang do
    build 503
    cause "Host Clang must be able to find libstdc++4.7 or newer!"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      system "cmake", "..", "-G", "Ninja", *std_cmake_args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<-EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
