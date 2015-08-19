require "formula"

class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "http://vrpn.org"
  url "http://www.cs.unc.edu/Research/vrpn/downloads/vrpn_07_33.zip"
  sha1 "3c908c333e501aeb5051484fafbb89e79064ba20"

  head "git://git.cs.unc.edu/vrpn.git"

  bottle do
    cellar :any
    sha1 "2f168416e7caaa0e7ed4237d3532cd6ee37ecad5" => :yosemite
    sha1 "c8830aa818e3592eb2f6377ab452b7b35ee0eefd" => :mavericks
    sha1 "e6b3bf7f324622ce133e0ab3cf851d9ead3e1b54" => :mountain_lion
  end

  option "clients", "Build client apps and tests"
  option "with-docs", "Build doxygen-based API documentation"
  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    ENV.libstdcxx

    args = std_cmake_args

    if build.include? "clients"
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make doc" if build.with? "docs"
      system "make install"
    end
  end
end
