require "formula"

class Libfreenect < Formula
  homepage "http://openkinect.org"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.0.tar.gz"
  sha1 "3a0c6ca9b2515132a59232ed5719ee2731f6e580"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    revision 1
    sha1 "01f9e79b4be90a3a5487fe19e2ee54a62b732ed9" => :yosemite
    sha1 "61ee80a144a0ca7a2b89ab6fec33524aa745bd67" => :mavericks
    sha1 "39b2d3e43dc3e0de01b000c6ea9347b276af8383" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make install"
    end
  end
end
