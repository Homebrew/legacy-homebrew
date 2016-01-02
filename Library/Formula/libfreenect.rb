class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.1.tar.gz"
  sha256 "97e5dd11a0f292b6a3014d1a31c7af16a21cd6574a63057ed7a364064a7614d0"

  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    revision 1
    sha256 "b1a6522fbcfad660703f1f86bafded7cbe4050ecd95a53481e5ccaa5bae7b86f" => :el_capitan
    sha256 "3747228221eaf4e35b18f07fb2f57dfb85cd1787d5b8534e7174d16820534cbf" => :yosemite
    sha256 "0923504aaedced53b34a1a1d5a7b32a4b2573926ba462b4b44e9ba0cac85d61a" => :mavericks
    sha256 "f1a1590a8ae0ad8baa18b82e95a2bd24fb5be9bae152f816780114c236ba85e6" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"

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
