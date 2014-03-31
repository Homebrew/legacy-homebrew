require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url 'http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2'
  sha1 'f05ade5614aa31e64f91a30ce3782f7ca3704d18'

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
