class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.10.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.10/doxygen-1.8.10.src.tar.gz"
  sha256 "cedf78f6d213226464784ecb999b54515c97eab8a2f9b82514292f837cf88b93"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any
    sha256 "664da46bf3ba19ef12a03e78ea71cbdf7934c42968dfe4696e14efb9a6cc56fc" => :yosemite
    sha256 "a125ae2932468010f0472b57ec52c7d4d336490a4fbf5521cd18f0ad246b214f" => :mavericks
    sha256 "e449b59679f8113de1d24860654c2fb4ed56631ef9cc493b759451685585be0e" => :mountain_lion
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
