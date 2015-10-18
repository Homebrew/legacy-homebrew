class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2"
  sha256 "c0b1af1a13e2c6682a1d8041e5b164a1e0d90267cd378bb51e059bd62f821e21"

  bottle do
    cellar :any
    revision 3
    sha256 "b28b36691a275c37eab79408d1ee26fd3f74a11949ba88e5325950d9c32207cc" => :el_capitan
    sha256 "2d0e66492ec3e14195a33471c44c134a0e871f51b41cf0378a1b310ac0c43210" => :yosemite
    sha256 "812990757cde2fdc96d97fcdb9e4e82ee13113c88f036c52c42f37466b352550" => :mavericks
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
