require 'formula'

class Qcachegrind < Formula
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.1.tgz'
  homepage 'http://kcachegrind.sourceforge.net/'
  md5 '39376990a9ea2e9f1b75f43f9104fd70'

  depends_on 'graphviz' => :optional
	depends_on 'qt'

  def install
    cd 'qcachegrind'
    system 'qmake -spec macx-g++ -config release'
    system 'make'
    bin.install 'qcachegrind.app/Contents/MacOS/qcachegrind'
  end

  def test
    system 'qcachegrind'
  end
end
