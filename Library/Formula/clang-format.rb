class ClangFormat < Formula
  desc "C, C++, Obj-C, Java, JavaScript, TypeScript formatting tools and editor plugins"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2015-06-18"

  bottle do
    cellar :any
    sha256 "bace422bbad1e05f889c2e35325897f25a5d25288584059eb0eed13430a29ec9" => :yosemite
    sha256 "1529788bc854b6ff23ed688b092f0cdaef82a747ae4619596aca78c5c0b656db" => :mavericks
    sha256 "4df7ba32d7930031848e5387db341b9dedad6f914c0f4993d8a27c67fa471fdf" => :mountain_lion
  end

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/testing/2015-06-18/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/testing/2015-06-18/", :using => :svn
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
