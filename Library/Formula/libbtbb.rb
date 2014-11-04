require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R3.tar.gz"
  sha1 "b42c19cd1965b18409661d765734adec9c1f7449"
  version "2014-02-R3"

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
