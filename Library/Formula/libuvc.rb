require 'formula'

class Libuvc < Formula
  homepage 'https://github.com/ktossell/libuvc'
  url 'https://github.com/ktossell/libuvc/archive/v0.0.2.tar.gz'
  sha1 'e0d57007715eaf36c5ebeb8d348488984c681041'

  depends_on 'libusb'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
