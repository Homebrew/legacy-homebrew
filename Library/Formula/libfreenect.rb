require 'formula'

class Libfreenect < Formula
  url 'https://github.com/OpenKinect/libfreenect/tarball/v0.1.2'
  head 'https://github.com/OpenKinect/libfreenect.git'
  homepage 'http://openkinect.org'
  sha1 'c2db5080dd1d471ed6e2a361b6345cd8fb1768c7'

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
