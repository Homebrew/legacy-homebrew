require 'formula'

class Opencv < Formula
  homepage 'http://opencv.org/'
  url 'http://downloads.sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.5/opencv-2.4.5.tar.gz'
  sha1 '9e25f821db9e25aa454a31976ba6b5a3a50b6fa4'

  depends_on 'cmake' => :build
  depends_on 'gtk+'  => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end
end
