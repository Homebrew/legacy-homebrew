require "formula"

class Libusb < Formula
  homepage "http://libusb.info"
  url "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.19/libusb-1.0.19.tar.bz2"
  sha256 "6c502c816002f90d4f76050a6429c3a7e0d84204222cbff2dce95dd773ba6840"

  bottle do
    cellar :any
    sha1 "978dfaba5e7a6b624f33e5e927994e89c9f22509" => :mavericks
    sha1 "f1e2c2b829556cc5ce5965a709ae0fb6c2e29dc9" => :mountain_lion
    sha1 "6e15e38d4c0cc8bd162b0dc475099b25ff651636" => :lion
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "no-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.include? "no-runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end
