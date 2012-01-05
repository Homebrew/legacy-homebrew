require 'formula'

class Kruler < Formula
  url 'http://download.kde.org/stable/4.7.4/src/kruler-4.7.4.tar.bz2'
  homepage 'http://kde.org'
  md5 '064505a9c03839225eb04a1604874efb'

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
