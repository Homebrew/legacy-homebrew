require 'formula'

class OxygenIcons <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.6.0/src/oxygen-icons-4.6.0.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '47b943e1b8bc2c1cef10fd791ac70091'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
