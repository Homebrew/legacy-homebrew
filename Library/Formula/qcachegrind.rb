require 'formula'

class Qcachegrind < Formula
  homepage 'http://kcachegrind.sourceforge.net/html/Home.html'
  url 'http://kcachegrind.sourceforge.net/kcachegrind-0.7.1.tgz'
  sha1 'efa0b3abb7afe211c2f227b78a8699d80846f8ea'

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

  def caveats; <<-EOS
    qcachegrind.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
