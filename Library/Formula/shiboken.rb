require 'formula'

class Shiboken <Formula
  url 'http://www.pyside.org/files/shiboken-1.0.0.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 'f732efeef712bc93b34a1fae2305d5ac'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
