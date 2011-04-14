require 'formula'

class Yafaray <Formula
  head 'git://github.com/YafaRay/Core.git', :branch => 'Release-0.1.2'
  homepage 'http://www.yafaray.org/'

  depends_on 'cmake' => :build
  depends_on 'libxml2'
  depends_on 'openexr'
  depends_on 'jpeg'

  def install
    system "cmake . #{std_cmake_parameters} -DWITH_QT=OFF -DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "make install"
  end
end
