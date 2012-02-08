require 'formula'

class Scantailor < Formula
  homepage 'http://scantailor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/scantailor/scantailor/0.9.11/scantailor-0.9.11.tar.gz'
  md5 '15984c8828ecb2de542ac94e3c41a810'

  devel do
    url 'http://downloads.sourceforge.net/project/scantailor/scantailor-devel/enhanced/scantailor-enhanced-20110907.tar.gz'
    md5 '8ba5c23c611e7bdd7cdb40f991f6fd35'
    version 'enhanced-20110907'
  end

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
