require "formula"

class Libfreenect < Formula
  homepage "http://openkinect.org"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.1.tar.gz"
  sha1 "1f7296e50c27c07e2f57ee906c195cabf97c1438"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha1 "431e5bc789920cdc34e2a786fd44eb4485dd7e3d" => :yosemite
    sha1 "98c11049dd822039eaa7325fa9dc2131c4a4b3dd" => :mavericks
    sha1 "1e5ec1cc7a91d583f3de9c5f12d5eac8321970e4" => :mountain_lion
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
