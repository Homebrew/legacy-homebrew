require "formula"

class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R4.tar.gz"
  sha1 "281bb4a68f5e79553d704a6fe5256944338ac4b3"
  version "2014-02-R4"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha1 "e1870ab678e92b9524d3f1ea05862fedc3d196eb" => :yosemite
    sha1 "52071cec084c13a10a08102e391f457d176ecd1d" => :mavericks
    sha1 "3069f205340202284cd8e0ec902d056c4f851bba" => :mountain_lion
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
