require 'formula'

class Libreplaygain < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/libreplaygain_r475.tar.gz'
  version 'r475'
  md5 'e27b3b1249b7fbae92d656d9e3d26633'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    include.install 'include/replaygain/'
  end
end
