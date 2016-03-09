class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2016-03-08"

  stable do
    url "http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz"
    sha256 "555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46"

    resource "clang" do
      url "http://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz"
      sha256 "04149236de03cf05232d68eb7cb9c50f03062e339b68f4f8a03b650a11536cf9"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e6b26890dc59982f2beb0bf45a6de51c5f63dbcc9739f583a84c47495eae2fa3" => :el_capitan
    sha256 "f6cd9d90f3acbac3cfbce746ba476f3c1b8633787a9d6bddef1d12dae2f1b563" => :yosemite
    sha256 "114b346b627ffb49e03d28fb20d0ebe6380090478795cc43b503ba841db4016c" => :mavericks
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
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
