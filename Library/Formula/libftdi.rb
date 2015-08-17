class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "http://www.intra2net.com/en/developer/libftdi"
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2"
  sha256 "c0b1af1a13e2c6682a1d8041e5b164a1e0d90267cd378bb51e059bd62f821e21"

  bottle do
    revision 1
    sha1 "23a46b49c327ff94e990f6677f343513f86cce45" => :yosemite
    sha1 "f79c80ca34c4108a8d8b95e0814ee2316110ba1d" => :mavericks
    sha1 "c0f8000f19d4910525fec572944115823e21bdfc" => :mountain_lion
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
