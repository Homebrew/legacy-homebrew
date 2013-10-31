require 'formula'

class Libusbx < Formula
  homepage 'http://libusbx.org'
  url 'http://downloads.sourceforge.net/project/libusbx/releases/1.0.17/source/libusbx-1.0.17.tar.bz2'
  sha1 'a491054e7f4f3f52b12bd567335180586a54ae16'

  head do
    url 'https://github.com/libusbx/libusbx.git'

    depends_on :automake
    depends_on :libtool
  end


  conflicts_with 'libusb',
    :because => 'both provide libusb compatible libraries'

  option :universal
  option 'no-runtime-logging', 'Build without runtime logging functionality'
  option 'with-default-log-level-debug' 'Build with default runtime log level of debug (instead of none)'

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.include? 'no-runtime-logging'
    args << "--enable-debug-log" if build.include? 'with-default-log-level-debug'
    system "./configure", *args
    system "make install"
  end
end
