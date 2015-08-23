class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"

  head "https://github.com/apngasm/apngasm.git"

  bottle do
    cellar :any
    sha1 "cbc3eaa12b5070ecafd3183003ff09c7c3d7e108" => :yosemite
    sha1 "d2034f6c75bf7eb5da4eef5bb3e50fb33b79ae68" => :mavericks
    sha1 "209d32e1fb51d7ba730452892775f2df32e2a526" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (pkgshare/"test").install "test/samples"
  end

  test do
    system "apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
