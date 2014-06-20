require 'formula'

class Libusb < Formula
  homepage 'http://libusb.info'
  url 'https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.18/libusb-1.0.18.tar.bz2'
  sha256 'c73f5cec45a5de94418da4e151b7232958571926984acfb9bce02b9424e83720'

  bottle do
    cellar :any
    sha1 "a49364f9964a1198159d2ed1645dabb5770013bf" => :mavericks
    sha1 "6bbf08c8fbd747d00dbe67d03be150b5950cf482" => :mountain_lion
    sha1 "e8863bdf84a928a79b07f48fabe6b15fddd74296" => :lion
  end

  head do
    url 'https://github.com/libusb/libusb.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option 'no-runtime-logging', 'Build without runtime logging functionality'
  option 'with-default-log-level-debug', 'Build with default runtime log level of debug (instead of none)'

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.include? 'no-runtime-logging'
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end
