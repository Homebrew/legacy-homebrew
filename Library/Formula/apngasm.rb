require "formula"

class Apngasm < Formula
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.4.tar.gz"
  sha1 "62bd9f829b383a4f53f4bb1018f1e2d24a846272"

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
    (share/'test').install "test/samples"
  end

  test do
    system "apngasm", "#{share}/test/samples/clock*.png"
  end
end
