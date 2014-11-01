require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R3.tar.gz"
  sha1 "b42c19cd1965b18409661d765734adec9c1f7449"
  version "2014-02-R3"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    revision 1
    sha1 "7e326c07fe6042820a6ae908d1b1bf430e0dc188" => :yosemite
    sha1 "03762cffc3c0c1b5e4701bbc591e585cd3ff8ce0" => :mavericks
    sha1 "8b922ed4da9a46e0c0b963d801fcae04f74c74bd" => :mountain_lion
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
