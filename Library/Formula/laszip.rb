require 'formula'

class Laszip < Formula
  homepage 'http://www.laszip.org/'
  url 'https://github.com/LASzip/LASzip/archive/2.0.2.tar.gz'
  sha1 '42c27cf3beff50f53e51d4a1b921e3b9f3b0faf7'
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
