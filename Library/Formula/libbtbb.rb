require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R4.tar.gz"
  sha1 "281bb4a68f5e79553d704a6fe5256944338ac4b3"
  version "2014-02-R4"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha1 "9ce274e76c4e44bb9d5ff166b0f920ef2b6d7997" => :yosemite
    sha1 "c35dcd7c94a2ca00db402954b1eabba33f3bab7b" => :mavericks
    sha1 "3238e7c992e725806f3bea8b683638ab337978ab" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "python"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
