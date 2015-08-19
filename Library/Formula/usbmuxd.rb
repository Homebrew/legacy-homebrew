class Usbmuxd < Formula
  desc "USB multiplexor daemon for iPhone and iPod Touch devices"
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
  sha256 "1aa21391265d2284ac3ccb7cf278126d10d354878589905b35e8102104fec9f2"

  bottle do
    cellar :any
    revision 1
    sha1 "f9cb14678e5e2dbee3f189641d8d390bee938fd3" => :yosemite
    sha1 "1ee806476cda65d5904431815f949dd6074e7a7e" => :mavericks
    sha1 "09014c177d40d10c0a10b5540c92023316382a5f" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/libusbmuxd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libplist"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
