class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "http://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2015.07.tar.gz"
  sha256 "9e15911ab39ba1eb4aa1bcbf518a0eac5396207fc4a58c32b2550fe0a65f9d22"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "host/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
