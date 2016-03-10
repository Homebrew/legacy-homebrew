class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "http://www.airspy.com"
  url "https://github.com/airspy/host/archive/v1.0.7.tar.gz"
  sha256 "c7efbe3acd5b72ac9cc8ce46651e81c6adecbe3491dddf5a2bf8ef4ad14b2fb2"
  head "https://github.com/airspy/host.git"

  bottle do
    sha256 "f427d4d9c4d5f18803b1b7d42380bd78cd9634beab26f9f7846b0058248e3bd6" => :el_capitan
    sha256 "cce06c58409d0c8c425eed8c85c670320a88b0d645034ae717bbc651b7bfbd26" => :yosemite
    sha256 "d21d562a1f78c354bda2a90451c73db9526a40f5b9a54c2b9733b2221732c2cf" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-1.0"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib}/libusb-1.0.dylib"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version").chomp
  end
end
