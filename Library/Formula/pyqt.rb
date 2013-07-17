require 'formula'

class Pyqt < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  url 'http://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.10.2/PyQt-mac-gpl-4.10.2.tar.gz'
  sha1 '40362e6b9f476683e4e35b83369e30a8dfff99ad'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  depends_on 'qt'  # From their site: PyQt currently supports Qt v4 and will build against Qt v5

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
      ['pyuic4', 'pyrcc4', 'pylupdate4'].each { |f| mv(prefix/"bin3/#{f}", bin/"#{f}-py3")}
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
        from PyQt4 import QtGui, QtCore

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
