require 'formula'

class Pyqt5 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt/download5'
  url 'http://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.0/PyQt-gpl-5.0.tar.gz'
  sha1 'todo'

  depends_on :python3 => :recommended
  depends_on :python2 => :optional

  depends_on 'qt5'

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
  end

  def install
    python do
      system python, "./configure.py", "--confirm-license",
                                       "--bindir=#{bin}#{python.if3then3}",
                                       "--destdir=#{lib}/#{python.xy}/site-packages",
                                       "--sipdir=#{share}/sip#{python.if3then3}"
      system "make"
      system "make", "install"
      system "make", "clean"  # because this python block may be run twice
    end

    if python3
      # These tools need a unique suffix for python3.
      ['pyuic5', 'pyrcc5', 'pylupdate5'].each { |f| mv(prefix/"bin3/#{f}", bin/"#{f}-py3")}
      rm_rf prefix/'bin3'
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    python do
      # Reference: http://zetcode.com/tutorials/pyqt4/firstprograms/
      (testpath/'test.py').write <<-EOS.undent
        import sys
        from PyQt5 import QtGui, QtCore

        class Test(QtGui.QWidget):
            def __init__(self, parent=None):
                QtGui.QWidget.__init__(self, parent)
                self.setGeometry(300, 300, 400, 150)
                self.setWindowTitle('Homebrew')
                QtGui.QLabel("Python #{python.version} working with PyQt4. Quitting now...", self).move(50, 50)
                QtCore.QTimer.singleShot(2500, QtGui.qApp, QtCore.SLOT('quit()'))

        app = QtGui.QApplication([])
        window = Test()
        window.show()
        sys.exit(app.exec_())
        EOS

      system python, "test.py"
      rm testpath/'test.py'
    end
  end
end
