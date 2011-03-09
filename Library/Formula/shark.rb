require 'formula'

class Shark <Formula
  url 'http://downloads.sourceforge.net/project/shark-project/Shark%20Core/Shark%202.3.2/shark-2.3.2.tar.bz2'
  homepage 'http://shark-project.sourceforge.net/'
  md5 'e149c77b9f9722c93d9fac21b2abee10'

  depends_on 'cmake'

  def install
    Dir.chdir('cmake')
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
