class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2"
  sha256 "cb057190ba0a961768224e4dc6883104c6f945b2bf2ef90d7da39e7c1834f7ff"

  bottle do
    cellar :any
    sha256 "f04c366717f0ddeef3871f767242f50cf07aefc16f260e11e2f916fe7c17d6fd" => :el_capitan
    sha256 "f041c11fe5402b585f2617640cd374b032fb314bebeadc2ad0202bf306bc4532" => :yosemite
    sha256 "a156b5968853363f5465d7a281cdc536d03d77f26fd98ed7196363b0af41bbb0" => :mavericks
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
