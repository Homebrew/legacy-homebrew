require 'formula'

class Scantailor <Formula
  url 'http://downloads.sourceforge.net/project/scantailor/scantailor/0.9.9.2/scantailor-0.9.9.2.tar.gz'
  homepage 'http://scantailor.sourceforge.net/'
  md5 '0944b12c936019fe12269c7a356d60d0'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'jpeg'
  depends_on 'boost'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
