class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2015-07-31"

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

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1d96606c434cbf92807f5e1b33d4bd5b7eababb680e9a373f2445b37c1214010" => :el_capitan
    sha256 "5e808795acb2acc436d80066e717431e0a1b01ef3a3d56b10aa897ada6c8d45e" => :yosemite
    sha256 "ced2d7917db53c229b14d4744a39e02657ffc15dc54bd032b2d3010527f7e214" => :mavericks
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
