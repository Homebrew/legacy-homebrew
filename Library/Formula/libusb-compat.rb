class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "http://www.libusb.org/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
  sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"

  bottle do
    cellar :any
    revision 1
    sha256 "df7e556f8af9bccb149bb26becc8a2e6cd9a3d22fc04b2ebf81e981abc892fef" => :el_capitan
    sha1 "98881038beb113fcfe91bff9a531e48099eda615" => :yosemite
    sha1 "798b32ab3ad03641b6d95a9a219730e4fb977c09" => :mavericks
    sha1 "f0e4dec2847f1cfa6f759a00de6e35e3cdbde927" => :mountain_lion
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
