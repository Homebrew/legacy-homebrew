require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url 'http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2'
  sha1 'f05ade5614aa31e64f91a30ce3782f7ca3704d18'

  bottle do
    sha1 "e25c43400941c91b1d5d448e56337ac35414b57a" => :mavericks
    sha1 "1f19955417827090f1f933785182db99c05cf298" => :mountain_lion
    sha1 "3a6172354be05059281c40d48c489b558da4eef4" => :lion
  end

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
