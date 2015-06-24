class ClangFormat < Formula
  desc "C, C++, Obj-C, Java, JavaScript, TypeScript formatting tools and editor plugins"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2015-06-18"

  bottle do
    cellar :any
    revision 1
    sha256 "d468eade3434b83409053931e6489d8d5a15c0e0478c6eebdd8afe7525358322" => :yosemite
    sha256 "0df98e127d8fd41adabb058edac78937d95862fe2eaf35cdbfe8230167c3c090" => :mavericks
    sha256 "8a2169b7267c18371984640be6899c35bc3bae278ca535e7017af4a79fb58dd8" => :mountain_lion
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
