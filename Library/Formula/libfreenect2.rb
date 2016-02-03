class Libfreenect2 < Formula
  desc "Drivers and libraries for the Xbox One Kinect 2 device"
  homepage "https://github.com/OpenKinect/libfreenect2"
  url "https://github.com/OpenKinect/libfreenect2/archive/v0.1.1.tar.gz"
  sha256 "4fcad0627468bedd237711b48b70a997ee8dcf30e0f1ecf9e882a0200ce647bf"

  head "https://github.com/OpenKinect/libfreenect2.git"

  option :universal

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "jpeg-turbo"
  depends_on "glfw"

  def install
    args = std_cmake_args

    inreplace "CMakeLists.txt", /FIND_PACKAGE\(LibUSB REQUIRED\)/, ""
    inreplace "CMakeLists.txt", /FIND_PACKAGE\(GLFW3\)/, "SET(GLFW3_FOUND 1)"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      args << "-DLibUSB_INCLUDE_DIRS=#{Formula["libusb"].include}/libusb-1.0"
      args << "-DLibUSB_LIBRARIES=usb-1.0"
      args << "-DGLFW3_INCLUDE_DIRS=#{Formula["glfw"].include}/GLFW"
      args << "-DGLFW3_LIBRARIES=glfw"
      system "cmake", "..", *args
      system "make", "install"
      bin.install Dir["bin/*"]
    end
  end

  test do
    system "#{bin}/Protonect", "--version"
  end
end
