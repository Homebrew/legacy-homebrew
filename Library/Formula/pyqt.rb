require 'formula'

class Pyqt < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  url 'http://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.10.1/PyQt-mac-gpl-4.10.1.tar.gz'
  sha1 'cf20699c4db8d3031c19dd51df8857bba1a4956b'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  depends_on 'sip' => ['with-python3'] if build.with? 'python3'
  depends_on 'qt'  # From their site: PyQt currently supports Qt v4 and will build against Qt v5

  def install
    python do
      system python, "./configure.py", "--confirm-license",
                                       "--bindir=#{bin}#{python.if3then3}",
                                       "--destdir=#{lib}/#{python.xy}/site-packages",
                                       "--sipdir=#{share}/sip#{python.if3then3}"
      system "make"
      system "make install"
      system "make clean"  # because this python block may be run twice
    end

    if python3
      # These tools need a unique suffix for python3.
      ['pyuic4', 'pyrcc4', 'pylupdate4'].each { |f| mv(prefix/"bin3/#{f}", bin/"#{f}-py3")}
      rm_rf prefix/'bin3'
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    python do
      # Todo: For brew-test-bot we need to add a timer that quits after 1 s or so.

      # Reference: http://zetcode.com/tutorials/pyqt4/firstprograms/
      (testpath/'test.py').write <<-EOS.undent
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

      system python, "test.py"
      rm testpath/'test.py'
    end
  end
end
