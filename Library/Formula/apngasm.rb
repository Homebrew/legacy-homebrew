class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"

  head "https://github.com/apngasm/apngasm.git"

  bottle do
    cellar :any
    sha256 "ab2011a6528d8e9fb38b72473fda3932f1087d4bdc8fd1402adbcac8f19ca678" => :yosemite
    sha256 "37fca4b69383dfbaf247ce99e8f7414fa3046bda30f3443c0291c3906a21d298" => :mavericks
    sha256 "a1898e9debc434fcbc93ae2a0e62a2ae8175eaca856b4118d9fcb99df7dc6d94" => :mountain_lion
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
