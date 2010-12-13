require 'formula'

class Zint <Formula
  url 'http://downloads.sourceforge.net/project/zint/zint/2.4/zint-2.4.0.src.tar.gz'
  homepage 'http://www.zint.org.uk'
  md5 '31fbb05dc45d3c460075096b702cefb0'
  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  depends_on 'cmake'
  depends_on 'libpng'

  def install
    mkdir('build')
    cd('build')
    system "cmake ..  #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{prefix} -DCMAKE_C_FLAGS=-I#{Formula.factory('libpng').include}"
    system "make install"
  end
end
