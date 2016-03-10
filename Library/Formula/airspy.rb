class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "http://www.airspy.com"
  url "https://github.com/airspy/host/archive/v1.0.7.tar.gz"
  sha256 "c7efbe3acd5b72ac9cc8ce46651e81c6adecbe3491dddf5a2bf8ef4ad14b2fb2"
  head "https://github.com/airspy/host.git"

  bottle do
    sha256 "779886bf64def8c0ab4920d54d854d01a341c25e8df112d22eac4d3a65db8f87" => :el_capitan
    sha256 "e0ac61c9efdb4bea5288f5d096d16d101b239b69e51e77828b824c7b0e84262e" => :yosemite
    sha256 "e51fa70fe50b431ec4560b1748717c4050999b6eb75c6f60c6412bacb1dcb4ea" => :mavericks
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
