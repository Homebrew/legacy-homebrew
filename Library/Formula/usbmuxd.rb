class Usbmuxd < Formula
  desc "USB multiplexor daemon for iPhone and iPod Touch devices"
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
  sha256 "1aa21391265d2284ac3ccb7cf278126d10d354878589905b35e8102104fec9f2"

  bottle do
    cellar :any
    revision 1
    sha256 "187e9dd2acbe0e80a92d72a1e0a2f61b37ff04d1defe22a88e5e26af4ca29e97" => :el_capitan
    sha256 "83ab2b17215f3acec1787023d6177e1893301badecf7383b7ed1fa6133b7919a" => :yosemite
    sha256 "13f348d39eb5191bfb4940ee569b9e2d986632542ec7d876a6e8aebe72f0ebeb" => :mavericks
    sha256 "3c3583976e0c06b67304a2432723e477df7b7c6861bb0fc4c7a82b3b1314212e" => :mountain_lion
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
