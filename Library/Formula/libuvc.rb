class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha256 "62652a4dd024e366f41042c281e5a3359a09f33760eb1af660f950ab9e70f1f7"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    revision 1
    sha1 "600fa35a693bccc80b44f731acc9cd945c35181d" => :yosemite
    sha1 "b292f190f52e1e659aa3c2e51c19f15b421fb01e" => :mavericks
    sha1 "6216c3b15fc83f9612b8573999d0dc537381a20b" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "jpeg" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
