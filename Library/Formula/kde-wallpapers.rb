require 'formula'

class KdeWallpapers < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kde-wallpapers-4.7.4.tar.bz2'
  homepage 'http://kde.org/'
  md5 'e3606013a1406ba87293aa5948a6c123'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
