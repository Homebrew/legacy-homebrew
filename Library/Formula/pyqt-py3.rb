require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class PyqtPy3 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  url 'http://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.9.4/PyQt-mac-gpl-4.9.4.tar.gz'
  sha1 '3fe827fed91ec710746fa980f433313dfec2d5fd'

  depends_on 'sip-py3'
  depends_on 'qt'
  conflicts_with 'pyqt'

  def install
    ENV.prepend 'PATH', "/usr/local/bin", ':'
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python3}/site-packages", ':'

    system "python3", "./configure.py", "--confirm-license",
                                       "--bindir=#{bin}",
                                       "--destdir=#{lib}/#{which_python3}/site-packages",
                                       "--sipdir=#{share}/sip-py3"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python3}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python3
    "python" + `python3 -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    # Reference: http://zetcode.com/tutorials/pyqt4/firstprograms/
    mktemp do
      ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python3}/site-packages", ':'

      (Pathname.pwd/'test.py').write <<-EOS.undent
        #!/usr/bin/env python3

        import sys
        from PyQt4 import QtGui, QtCore

        class QuitButton(QtGui.QWidget):
            def __init__(self, parent=None):
                QtGui.QWidget.__init__(self, parent)

                self.setGeometry(300, 300, 250, 150)
                self.setWindowTitle('Quit button')

                quit = QtGui.QPushButton('Close', self)
                quit.setGeometry(10, 10, 60, 35)

                self.connect(quit, QtCore.SIGNAL('clicked()'),
                    QtGui.qApp, QtCore.SLOT('quit()'))

        app = QtGui.QApplication(sys.argv)
        qb = QuitButton()
        qb.show()
        app.exec_()
        sys.exit(0)
        EOS

      system "python3", "test.py"
    end
  end
end
