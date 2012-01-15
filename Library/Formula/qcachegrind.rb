require 'formula'

class Qcachegrind < Formula
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.0.tar.gz'
  homepage 'http://kcachegrind.sourceforge.net/'
  md5 '0001385bbc630afa353619de8768e946'

  depends_on 'graphviz' => :optional

  def install
    qt = Formula.factory 'qt'
    unless (qt.lib + 'Qt3Support.framework').exist?
      onoe 'QCachegrind requires Qt3Support. `brew install qt --with-qt3support`'
      exit 1
    end

    cd 'qcachegrind'
    system 'qmake -spec macx-g++ -config release'
    system 'make'
    bin.install 'qcachegrind.app/Contents/MacOS/qcachegrind'
  end

  def test
    system 'qcachegrind'
  end
end
