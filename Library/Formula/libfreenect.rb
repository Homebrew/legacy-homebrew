require 'formula'

class Libfreenect < Formula
  homepage 'http://openkinect.org'
  url 'https://github.com/OpenKinect/libfreenect/archive/v0.4.1.tar.gz'
  sha1 'a72bf3d60a859fb5b54b30d6e5d52c8359c07888'

  head 'https://github.com/OpenKinect/libfreenect.git'

  option :universal

  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make install"
    end
  end
end
