require 'formula'

class Libfreenect < Formula
  homepage 'http://openkinect.org'
  url 'https://github.com/OpenKinect/libfreenect/archive/v0.2.0.tar.gz'
  sha1 'cc6ec1d48411439769d51a645f684a8aeedcf1f1'

  head 'https://github.com/OpenKinect/libfreenect.git'

  option :universal

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    if build.universal?
      ENV.universal_binary
      ENV['CMAKE_OSX_ARCHITECTURES'] = "i386;x86_64"
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
