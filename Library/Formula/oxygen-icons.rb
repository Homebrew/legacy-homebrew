require 'formula'

class OxygenIcons < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.3/src/oxygen-icons-4.7.3.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 'a211817dd168a6def9e9d3e983b3da8d'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
