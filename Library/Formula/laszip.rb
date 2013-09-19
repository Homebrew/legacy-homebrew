require 'formula'

class Laszip < Formula
  homepage 'http://www.laszip.org/'
  url 'https://github.com/LASzip/LASzip/archive/v2.2.0.tar.gz'
  sha1 '911881d7698642f6c201a70cab62a55a337b5627'
  head 'https://github.com/LASzip/LASzip.git'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "laszippertest"
  end
end
