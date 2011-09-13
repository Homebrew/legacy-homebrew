require 'formula'

class Scantailor < Formula
  url 'http://downloads.sourceforge.net/project/scantailor/scantailor/0.9.10/scantailor-0.9.10.tar.gz'
  homepage 'http://scantailor.sourceforge.net/'
  md5 'f962c93a2d63b449fa3f6612ade3b028'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    system "cmake . #{std_cmake_parameters} -DPNG_INCLUDE_DIR=/usr/X11/include"
    system "make install"
  end
end
