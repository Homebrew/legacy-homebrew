require "formula"

class Apngasm < Formula
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.3.tar.gz"
  sha1 "5968640a5610e5ab47ef8464e413e714d2ef64a5"

  bottle do
    cellar :any
    sha1 "5eb0b1a7c88a1196539add4e721cc30dd83f1697" => :mavericks
    sha1 "fc9b6c1e8910aca9282bee642bce50642ee6b976" => :mountain_lion
    sha1 "c568690023e0688e6b71cbe5dc9caab7e816420d" => :lion
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
