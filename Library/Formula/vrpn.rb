class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/v07.33/vrpn_07_33.zip"
  sha256 "3cb9e71f17eb756fbcf738e6d5084d47b3b122b68b66d42d6769105cb18a79be"
  head "https://github.com/vrpn/vrpn.git"

  bottle do
    cellar :any
    revision 2
    sha256 "83579f908bbae89a482bb8a6d54c91712e98035d822cf253505ef5b556d6d089" => :el_capitan
    sha256 "472ec68bd762b6dc35ef935e84bbe19f1443dcdeafc9d95256513346c51e0c43" => :yosemite
    sha256 "8828feb5b474f874ad3ae3033f6cbc716c31b2cdc9fb1b45b50e728171f115e4" => :mavericks
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
