require "formula"

class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "http://vrpn.org"
  url "https://github.com/vrpn/vrpn/releases/download/v07.33/vrpn_07_33.zip"
  sha256 "3cb9e71f17eb756fbcf738e6d5084d47b3b122b68b66d42d6769105cb18a79be"

  head "git://git.cs.unc.edu/vrpn.git"

  bottle do
    cellar :any
    revision 1
    sha256 "73fb695c441ca851fa126d5a08290ae0627097e62a8866bd886b4121d57312d5" => :yosemite
    sha256 "affbd0b4c9712ca37b36bca6978cb2c66a0e280ab471a38204d51780b7fb2a27" => :mavericks
    sha256 "edc3b260768bf854f98e36e487b1064f61f046b1104abbeb38a7c4ed25877487" => :mountain_lion
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
