require 'formula'

class Kamera < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kamera-4.7.4.tar.bz2'
  homepage 'http://www.thekompany.com/projects/gphoto/'
  md5 '5977355fb1dd14197fc78d5b90a6680c'

  depends_on 'cmake' => :build
  depends_on 'gphoto2'
  depends_on 'qt' # with --qt3-support

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
