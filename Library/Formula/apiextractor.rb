require 'formula'

class Apiextractor <Formula
  url 'http://www.pyside.org/files/apiextractor-0.10.0.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 '1e6825f71be0c912395ec7b5636cd613'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
