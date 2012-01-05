require 'formula'

class Korundum < Formula
  url 'http://download.kde.org/stable/4.7.4/src/korundum-4.7.4.tar.bz2'
  homepage 'http://kde.org'
  md5 'edfd9bafc3e63dacad63a6c577dcb43c'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'

  def install
    ENV.x11
    mkdir build
    cd build
    system "cmake .. #{std_cmake_parameters}"
    system "make install"
  end

end
