class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.2.tar.bz2"
  sha256 "a6ea795c829219015eb372b03008351cee3fb39f684bff3bf8a4620b558488d6"

  bottle do
    cellar :any
    sha256 "81690eae8fa778df6a48557d03b154fbb3fe726d27edf8c8cccfb0f440810c46" => :el_capitan
    sha256 "fe679703a4c73cdae3d5c893c411ae4f080c113c9aef2e7c290c6c7386e2357d" => :yosemite
    sha256 "4049462256cac963b49c6cb430be7458cfad761af6db42cfef19ac33c8a8eca6" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "boost" => :optional

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
