require 'formula'

class OxygenIcons < Formula
  url 'http://ftp.kde.org/stable/4.7.4/src/oxygen-icons-4.7.4.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '1ab8d750781249d84becca7f7eb988ed'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
