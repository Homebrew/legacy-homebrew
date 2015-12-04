class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "http://www.libusb.org/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
  sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"

  bottle do
    cellar :any
    revision 1
    sha256 "df7e556f8af9bccb149bb26becc8a2e6cd9a3d22fc04b2ebf81e981abc892fef" => :el_capitan
    sha256 "564b4c326a98e27c164544531535be57668ce242ca536a7b34e3716b20f8cd00" => :yosemite
    sha256 "264bc9dacd754bae665907cd087e06e7063d15fbad38b336c567f76e7f886193" => :mavericks
    sha256 "239e6f2a527713c38b4e802cd25b80fbb01af30a88a36b77b591f5e95890511f" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/libusb-config", "--libs"
  end
end
