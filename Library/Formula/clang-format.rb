class ClangFormat < Formula
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2015-04-02"

  bottle do
    cellar :any
    sha256 "79a12aaabc9806d374c21ca8b53a21e3bc1e13b039fd41ad2325a8bd269bb329" => :yosemite
    sha256 "f08ca4d9150aa7dcec0c2facfddea992c642d8014e41445000172d7737a61f29" => :mavericks
    sha256 "a9c87c981a293db81d04f520ac6602bcf77a43d69312533311c9dd1da3dc98c0" => :mountain_lion
  end

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/testing/2015-04-02/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/testing/2015-04-02/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.0/libcxx-3.6.0.src.tar.xz"
      sha1 "5445194366ae2291092fd2204030cb3d01ad6272"
    end
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.0/libcxx-3.6.0.src.tar.xz"
      sha1 "5445194366ae2291092fd2204030cb3d01ad6272"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
    bin.install "tools/clang/tools/clang-format/git-clang-format"
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
