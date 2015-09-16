class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2"
  sha256 "cb057190ba0a961768224e4dc6883104c6f945b2bf2ef90d7da39e7c1834f7ff"

  bottle do
    cellar :any
    revision 1
    sha256 "11ae6492cf30f3d137f72917ddf187aafc864c73d58b4a18b6da66209fbf9e7f" => :el_capitan
    sha1 "8e65bc4484e61141abc1ec0e16617713e4239ce8" => :yosemite
    sha1 "34ed99c7bd26ba888e0884be004ae93e567db595" => :mavericks
    sha1 "4558475bbe84d5ccdfc8ce342926715519d73f9b" => :mountain_lion
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
