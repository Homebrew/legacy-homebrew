require 'formula'

class Libfreenect < Formula
  homepage 'http://openkinect.org'
  url 'https://github.com/OpenKinect/libfreenect/archive/v0.4.0.tar.gz'
  sha1 'bec4c9f8a9e5ba39a874680882903858d52574df'

  head 'https://github.com/OpenKinect/libfreenect.git'

  option :universal

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    if build.universal?
      ENV.universal_binary
      ENV['CMAKE_OSX_ARCHITECTURES'] = Hardware::CPU.universal_archs.as_cmake_arch_flags
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
