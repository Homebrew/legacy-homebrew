class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"

  head "https://github.com/apngasm/apngasm.git"

  bottle do
    cellar :any
    revision 1
    sha256 "073f74cacea8907e430113f4aae80d248887fc1d18de36f64889e683c08e3441" => :el_capitan
    sha256 "5fb1bd67761e2717c78c3842c7effd8835acb5f6193a05516df7cde7ff7051e8" => :yosemite
    sha256 "124cee4bf9746a9e60882cf6fd5b2430265fc661af5dbe9bab2f85e83e985cfa" => :mavericks
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
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
