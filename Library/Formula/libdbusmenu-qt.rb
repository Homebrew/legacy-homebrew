require 'formula'

class LibdbusmenuQt < Formula
  homepage 'http://people.canonical.com/~agateau/dbusmenu/index.html'
  url 'http://launchpad.net/libdbusmenu-qt/trunk/0.7.0/+download/libdbusmenu-qt-0.7.0.tar.bz2'
  md5 '512dc3213afcf0c561ac28000e85a80d'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
