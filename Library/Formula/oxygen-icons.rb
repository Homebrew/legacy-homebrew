require 'formula'

class OxygenIcons <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.5.2/src/oxygen-icons-4.5.2.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '64cd34251378251d56b9e56a9d4d7bf6'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
