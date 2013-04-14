require 'formula'

class Libusbx < Formula
  homepage 'http://www.libusbx.org/'
  url 'http://downloads.sourceforge.net/project/libusbx/releases/1.0.14/source/libusbx-1.0.14.tar.bz2'
  sha1 '2896201c54a0a9d0aee724925ab58c96956d5251'
  head 'https://github.com/libusbx/libusbx.git'

  conflicts_with 'libusb',
    :because => 'libusb and libusbx install the same binaries.'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal
  option 'without-logging', 'disable all logging'
  option 'enable-logging', 'start with debug message logging enabled'
  option 'with-check', 'run tests if available; build examples'
  # examples are not installed, only tests are executed, 1.0.14 has no tests

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--enable-tests-build" if build.include?('with-check')
    args << "--enable-examples-build" if build.include?('with-check')
    args << "--disable-log" if build.include?('without-logging')
    args << "--enable-debug-log" if build.include?('enable-logging')
    system "./configure", *args
    system "make install"
    system "tests/stress" if build.include?('with-check') && build.head?
  end

  def test
    system "libusb-config", "--version"
  end
end
