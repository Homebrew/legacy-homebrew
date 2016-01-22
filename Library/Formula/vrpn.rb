class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/v07.33/vrpn_07_33.zip"
  sha256 "3cb9e71f17eb756fbcf738e6d5084d47b3b122b68b66d42d6769105cb18a79be"
  head "https://github.com/vrpn/vrpn.git"

  bottle do
    cellar :any
    revision 3
    sha256 "ea131270a6b130a525cf7c1be5fede216d00b97c11877d6223133e8f856590b5" => :el_capitan
    sha256 "23ac5436fdd15dccb7e661d0f50bdfe64b5765fdb3d636830dbc27e7af59c056" => :yosemite
    sha256 "d0f42ffa2bf57e011d59cf5fff15ab1a0ff9f1fe7a8183f06aa358c1dc173abb" => :mavericks
  end

  option "with-clients", "Build client apps and tests"
  option "with-docs", "Build doxygen-based API documentation"

  deprecated_option "docs" => "with-docs"
  deprecated_option "clients" => "with-clients"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libusb" # for HID support

  def install
    ENV.libstdcxx

    args = std_cmake_args
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"

    if build.with? "clients"
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "doc" if build.with? "docs"
      system "make", "install"
    end
  end
end
