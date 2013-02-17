require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class PyqtPython3 < Formula
  url 'http://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.9.4/PyQt-mac-gpl-4.9.4.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  sha1 '3fe827fed91ec710746fa980f433313dfec2d5fd'

  depends_on 'sip-python3'
  depends_on 'qt'

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'
    
    system which_python,
      "./configure.py",
      "--confirm-license",
      "--bindir=#{bin}",
      "--destdir=#{lib}/#{which_python}/site-packages",
      "--sipdir=#{share}/sip"

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python3 -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    test_program = <<-EOS
# Taken from: http://zetcode.com/tutorials/pyqt4/firstprograms/

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

    ohai "Writing test script 'test_pyqt.py'."
    open("test_pyqt.py", "w+") do |file|
      file.write test_program
    end
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'    
    system which_python,  "test_pyqt.py"

    ohai "Removing test script 'test_pyqt.py'."
    rm "test_pyqt.py"
  end
end
