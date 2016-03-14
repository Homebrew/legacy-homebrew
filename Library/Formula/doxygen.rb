class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.11/doxygen-1.8.11.src.tar.gz"
  sha256 "65d08b46e48bd97186aef562dc366681045b119e00f83c5b61d05d37ea154049"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79122ca4ad9d8a4a02171fbe26ea2b8100a5efbd7e98ffb57a6c1110050f7f3a" => :el_capitan
    sha256 "4136c8d0c7309b74d5e91e31a3c712bcaa3a1caacada0f768d3da73dc2a40485" => :yosemite
    sha256 "73ac008f6b99545d800c0c9672f42de733c88e4dcdc4f15b554a6c0917af9743" => :mavericks
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-doxywizard", "Build GUI frontend with qt support."
  option "with-libclang", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" if build.with? "doxywizard"
  depends_on "llvm" if build.with? "libclang"

  def install
    args = std_cmake_args
    args << "-Dbuild_wizard=ON" if build.with? "doxywizard"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "libclang"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
