require "formula"

class Libfreenect2 < Formula
  desc "Drivers and libraries for the Xbox Kinect device version 2"
  homepage "http://openkinect.org"

  head "https://github.com/OpenKinect/libfreenect2.git"

  option :universal

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "jpeg-turbo"

  def install
    args = std_cmake_args

    inreplace "examples/protonect/include/libfreenect2/protocol/usb_control.h", /libusb\.h/, "libusb-1\.0\/libusb\.h"
    inreplace "examples/protonect/include/libfreenect2/usb/transfer_pool.h", /libusb\.h/, "libusb-1\.0\/libusb\.h"
    inreplace "examples/protonect/src/event_loop.cpp", /libusb\.h/, "libusb-1\.0\/libusb\.h"
    inreplace "examples/protonect/include/libfreenect2/protocol/command_transaction.h", /libusb\.h/, "libusb-1\.0\/libusb\.h"
    inreplace "examples/protonect/src/libfreenect2.cpp", /libusb\.h/, "libusb-1\.0\/libusb\.h"
    inreplace "examples/protonect/CMakeLists.txt", /  \$\{LibUSB_LIBRARIES\}/, "usb-1.0"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "../examples/protonect", *args
      system "make install"
    end
  end
end
