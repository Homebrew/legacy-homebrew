require 'formula'

class Qcachegrind < Formula
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.0.tar.gz'
  homepage 'http://kcachegrind.sourceforge.net/'
  md5 '0001385bbc630afa353619de8768e946'

  #depends_on 'qt', '--with-qt3support'
  depends_on 'graphviz' => :optional

  def install
    if File.directory?("#{HOMEBREW_PREFIX}/lib/Qt3Support.framework") == false
      fail "QCachegrind requires Qt3Support. `brew install qt --with-qt3support`"
    end
    cd "qcachegrind"
    system "qmake -spec 'macx-g++'"
    system "make"
    bin.install "qcachegrind.app/Contents/MacOS/qcachegrind"
  end

  def test
    system "qcachegrind"
  end
end
