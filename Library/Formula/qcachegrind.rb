require 'formula'

class Qcachegrind < Formula
  homepage 'http://kcachegrind.sourceforge.net/html/Home.html'
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.4.tar.gz'
  sha1 'a727e6c39ad2809296dec4ca665f6fa99bda72fb'

  depends_on 'graphviz' => :optional
  depends_on 'qt'

  def install
    cd 'qcachegrind'
    system 'qmake -spec macx-g++ -config release'
    system 'make'
    # Install app
    prefix.install 'qcachegrind.app'
    # Symlink in the command-line version
    bin.install_symlink prefix/'qcachegrind.app/Contents/MacOS/qcachegrind'
  end
end
