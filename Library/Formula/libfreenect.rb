require "formula"

class Libfreenect < Formula
  homepage "http://openkinect.org"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.0.tar.gz"
  sha1 "2f74c27e8760b4d5d4973370aee9ca71301a6176"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha1 "c3688a5a4ba70b4402ab55b3b7a3edab2b423cd7" => :mavericks
    sha1 "3a58faa6c9aa9ba21b70cb83f5333a1b2e0a1139" => :mountain_lion
    sha1 "e191312fdb3a55c4c04cd7ae622d9b1d13558a79" => :lion
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
