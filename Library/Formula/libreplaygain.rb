require 'formula'

class Libreplaygain < Formula
  url 'http://files.musepack.net/source/libreplaygain_r475.tar.gz'
  homepage 'http://www.musepack.net/'
  md5 'e27b3b1249b7fbae92d656d9e3d26633'
  version 'r475'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
    include.install Dir['./include/replaygain/']
  end
end
