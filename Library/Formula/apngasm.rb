class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.4.tar.gz"
  sha256 "8767f992460f793c82ca1645e7744f3c49d15a7538c097b2bb233c7a04b65543"

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
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (share/"test").install "test/samples"
  end

  test do
    system "apngasm", "#{share}/test/samples/clock*.png"
  end
end
