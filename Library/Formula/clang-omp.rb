require "formula"

class ClangOmp < Formula
  homepage "http://clang-omp.github.io/"
  url "https://github.com/clang-omp/llvm", :using => :git, :tag => "1013141148"

  depends_on "cmake" => :build

  resource "compiler-rt" do
    url "https://github.com/clang-omp/compiler-rt", :using => :git, :tag => "1013141148"
    sha1 ""
  end

  resource "clang" do
    url "https://github.com/clang-omp/clang", :using => :git, :branch => "clang-omp", :tag => "1013141148"
    sha1 ""
  end

  def install
    resource("compiler-rt").stage { (buildpath/'projects/compiler-rt').install Dir['*'] }
    resource("clang").stage { (buildpath/'tools/clang').install Dir['*'] }

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    mv bin/"clang", bin/"clang-omp"
  end

  test do
    system "#{bin}/clang", "-v"
    system "#{bin}/clang++", "-v"
  end

end
