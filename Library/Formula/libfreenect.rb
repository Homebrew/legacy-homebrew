require "formula"

class Libfreenect < Formula
  homepage "http://openkinect.org"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.0.tar.gz"
  sha1 "2f74c27e8760b4d5d4973370aee9ca71301a6176"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha1 "a44a43315958711c9b615a74e8e4fe21bafa698b" => :mavericks
    sha1 "52e31f93900a4a7a9f1cd66389a56e9ae7847aa1" => :mountain_lion
    sha1 "32df0c0c8c440b2606202661711293ed4ecdd2a0" => :lion
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
