require 'formula'

class Pyqt5 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt/download5'
  url 'http://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.2/PyQt-gpl-5.2.tar.gz'
  sha1 'a1c232d34ab268587c127ad3097c725ee1a70cf0'

  option 'enable-debug', "Build with debug symbols"

  depends_on :python
  depends_on 'qt5'
  depends_on 'sip'

  def install
    args = [ "--confirm-license",
             "--bindir=#{bin}",
             "--destdir=#{lib}/python2.7/site-packages",
             # To avoid conflicst with PyQt (for Qt4):
             "--sipdir=#{share}/sip/Qt5/",
             # sip.h could not be found automatically
             "--sip-incdir=#{Formula.factory('sip').opt_prefix}/include",
             # Force deployment target to avoid libc++ issues
             "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" ]
    args << '--debug' if build.include? 'enable-debug'

    system "python", "configure.py", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/'test.py').write <<-EOS.undent
      import sys
      from PyQt5 import QtGui, QtCore, QtWidgets

      class Test(QtWidgets.QWidget):
          def __init__(self, parent=None):
              QtWidgets.QWidget.__init__(self, parent)
              self.setGeometry(300, 300, 400, 150)
              self.setWindowTitle('Homebrew')
              QtWidgets.QLabel("Python " + "{0}.{1}.{2}".format(*sys.version_info[0:3]) +
                               " working with PyQt5. Quitting now...", self).move(50, 50)
              QtCore.QTimer.singleShot(1500, QtWidgets.qApp.quit)

      app = QtWidgets.QApplication([])
      window = Test()
      window.show()
      sys.exit(app.exec_())
    EOS
    system "python", "test.py"
  end
end
