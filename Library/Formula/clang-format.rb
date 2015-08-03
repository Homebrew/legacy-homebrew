class ClangFormat < Formula
  desc "C, C++, Obj-C, Java, JavaScript, TypeScript formatting tools and editor plugins"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2015-07-31"

  bottle do
    cellar :any
    sha256 "23f3215f23cd4bc36d9b37ee566a3482f7b70a3baa887730a83067934a300b10" => :yosemite
    sha256 "c645415feb57129f30247ade34fc25ca17fc9e72619d52f1b93b086cca411426" => :mavericks
    sha256 "280f1a6c6c1d7823739027582c568f32bd88ca5d96d946230e6a7bfeddd46962" => :mountain_lion
  end

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/testing/2015-07-31/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/testing/2015-07-31/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.2/libcxx-3.6.2.src.tar.xz"
      sha256 "52f3d452f48209c9df1792158fdbd7f3e98ed9bca8ebb51fcd524f67437c8b81"
    end
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.6.2/libcxx-3.6.2.src.tar.xz"
      sha256 "52f3d452f48209c9df1792158fdbd7f3e98ed9bca8ebb51fcd524f67437c8b81"
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
    (share/"clang").install Dir["tools/clang/tools/clang-format/clang-format*"]
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
