require 'formula'

class PysideQt47x <Formula
  url 'http://www.pyside.org/files/pyside-qt4.7+1.0.6.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 '2f502c1f2ff14de5f456c77a8d7a77d3'

  depends_on 'cmake'
  depends_on 'apiextractor'
  depends_on 'generatorrunner'
  depends_on 'shiboken'

  def install
    system "cmake . #{std_cmake_parameters} -DALTERNATIVE_QT_INCLUDE_DIR='/Library/Frameworks' -DSITE_PACKAGE='/Library/Python/2.7/site-packages'"
    system "make install"
  end
end
