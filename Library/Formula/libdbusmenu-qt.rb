require 'formula'

class LibdbusmenuQt <Formula
  url 'http://launchpad.net/libdbusmenu-qt/trunk/0.7.0/+download/libdbusmenu-qt-0.7.0.tar.bz2'
  homepage 'http://people.canonical.com/~agateau/dbusmenu/index.html'
  md5 '512dc3213afcf0c561ac28000e85a80d'

  depends_on 'qt'
  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
