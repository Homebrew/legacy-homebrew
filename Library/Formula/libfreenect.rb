require 'formula'

class Libfreenect < Formula
  homepage 'http://openkinect.org'
  url 'https://github.com/OpenKinect/libfreenect/archive/v0.1.2.tar.gz'
  sha1 'a20aada4c84a29f10ef1953c81404d2f256b21e6'

  head 'https://github.com/OpenKinect/libfreenect.git'

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
