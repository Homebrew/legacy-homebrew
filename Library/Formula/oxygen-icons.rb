require 'formula'

class OxygenIcons <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.1/src/oxygen-icons-4.4.1.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '9e91b94f2e743d5dc0bd740ed0acb025'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
