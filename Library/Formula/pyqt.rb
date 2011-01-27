require 'formula'

# Note: this project doesn't save old releases, so it breaks often as
# downloads disappear.

class Pyqt <Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/PyQt4/PyQt-mac-gpl-4.8.1.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  md5 '177fa10c6420d6f7fc745478fa64304a'

  depends_on 'sip'
  depends_on 'qt'

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/python", ':'

    system "python", "./configure.py", "--confirm-license",
                                       "--bindir=#{bin}",
                                       "--destdir=#{lib}/python",
                                       "--sipdir=#{share}/sip"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
EOS
  end

  def test
    test_program = <<-EOS
#!/usr/bin/env python
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

    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/python", ':'
    system "python test_pyqt.py"

    ohai "Removing test script 'test_pyqt.py'."
    rm "test_pyqt.py"
  end
end
