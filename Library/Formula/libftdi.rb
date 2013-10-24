require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url 'http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.0.tar.bz2'
  sha1 '5be76cfd7cd36c5291054638f7caf4137303386f'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libusb'
  depends_on 'boost' => :optional

  def install
    mkdir 'libftdi-build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
