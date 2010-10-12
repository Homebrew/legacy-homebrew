require 'formula'

class Qimageblitz <Formula
  url 'svn://anonsvn.kde.org/home/kde/tags/qimageblitz/0.0.6'
  version '0.0.6'
  homepage 'http://www.kde.org'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
