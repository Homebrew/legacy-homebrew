require 'formula'

class Qimageblitz < Formula
  homepage 'http://www.kde.org'
  url 'ftp://ftp.kde.org/pub/kde/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2'
  md5 '0ae2f7d4e0876764a97ca73799f61df4'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
