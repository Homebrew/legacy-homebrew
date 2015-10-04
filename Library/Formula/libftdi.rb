class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "http://www.intra2net.com/en/developer/libftdi"
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2"
  sha256 "c0b1af1a13e2c6682a1d8041e5b164a1e0d90267cd378bb51e059bd62f821e21"

  bottle do
    cellar :any
    revision 2
    sha256 "bd138350b6b994aad13e24eb73a90d436a43760484e84b859a517b7dac022e91" => :el_capitan
    sha256 "706627fb6c9e6a48b891b1bb8fd37aaa8182ea6c711567fca57c552e201e2c20" => :yosemite
    sha256 "937b569282e624dedab4a56792313cdaf1747844c04a6ad24191d7ff4b5f30d9" => :mavericks
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
