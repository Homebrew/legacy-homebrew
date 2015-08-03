class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.10.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.10/doxygen-1.8.10.src.tar.gz"
  sha256 "cedf78f6d213226464784ecb999b54515c97eab8a2f9b82514292f837cf88b93"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any
    sha1 "f327b4bc93e17884edd17638697566ae6b0a669e" => :yosemite
    sha1 "d92088aeb037bc881830d508076d88713ba00c96" => :mavericks
    sha1 "a1108f0c553124209cf2b1b65b8cb879a1d8cb47" => :mountain_lion
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-doxywizard", "Build GUI frontend with qt support."
  option "with-libclang", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" if build.with? "doxywizard"
  depends_on "llvm" => "with-clang" if build.with? "libclang"

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
