require 'formula'

class Libuvc < Formula
  homepage 'https://github.com/ktossell/libuvc'
  url 'https://github.com/ktossell/libuvc/archive/v0.0.3.tar.gz'
  sha1 'bd6868772e6e4b9c52431d7731c09df013b6cf43'

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
