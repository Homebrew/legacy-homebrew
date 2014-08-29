require "formula"

class Usbmuxd < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.9.tar.bz2"
  sha1 "7b05ee971ba277591b76040078df598e3710f6db"

  head "http://cgit.sukimashita.com/usbmuxd.git"

  bottle do
    cellar :any
    sha1 "04ec016adce512d2a52c53b98cbb9013108f8b62" => :mavericks
    sha1 "e02561205db81a77671cf702c32ba33d4f101b43" => :mountain_lion
    sha1 "772d3e99916859f1a03fbc8bddd251ded2243904" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libplist"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
