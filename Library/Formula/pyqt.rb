require 'formula'

class Pyqt < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt'
  url 'http://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.10.3/PyQt-mac-gpl-4.10.3.tar.gz'
  sha1 'ba5465f92fb43c9f0a5b948fa25df5045f160bf0'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  depends_on 'qt'  # From their site: PyQt currently supports Qt v4 and will build against Qt v5

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
  end

  def patches
    # On Mavericks we want to target libc++, but this requires a user specified
    # qmake makespec. Unfortunately user specified makespecs are broken in the
    # configure.py script, so we have to fix the makespec path handling logic.
    DATA
  end

  def install
    python do

      # On Mavericks we want to target libc++, this requires a non default qt makespec
      if ENV.compiler == :clang and MacOS.version >= :mavericks
        ENV.append "QMAKESPEC", "unsupported/macx-clang-libc++"
      end

      args = [ "--confirm-license",
               "--bindir=#{bin}",
               "--destdir=#{lib}/#{python.xy}/site-packages",
               "--sipdir=#{share}/sip#{python.if3then3}" ]
      # We need to run "configure.py" so that pyqtconfig.py is generated, which
      # is needed by PyQWT for determining the correct build settings. But do
      # the actual compile, we use the newer configure-ng.py.
      system python, "configure.py", *args
      (python.site_packages/'PyQt4').install 'pyqtconfig.py'

      # On Mavericks we want to target libc++, this requires a non default qt makespec
      if ENV.compiler == :clang and MacOS.version >= :mavericks
        args << "--spec" << "unsupported/macx-clang-libc++"
      end

      system python, "./configure-ng.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"  # because this python block may be run twice
    end

    if build.with? 'python3' and build.with? 'python'
      ['pyuic4', 'pyrcc4', 'pylupdate4'].each { |f| mv(bin/f, bin/"#{f}-py3")}
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    # To test Python 3.x, you have to `brew test pyqt --with-python3`
    Pathname('test.py').write <<-EOS.undent
      import sys
      from PyQt4 import QtGui, QtCore

      class Test(QtGui.QWidget):
          def __init__(self, parent=None):
              QtGui.QWidget.__init__(self, parent)
              self.setGeometry(300, 300, 400, 150)
              self.setWindowTitle('Homebrew')
              QtGui.QLabel("Python " + "{0}.{1}.{2}".format(*sys.version_info[0:3]) +
                           " working with PyQt4. Quitting now...", self).move(50, 50)
              QtCore.QTimer.singleShot(1500, QtGui.qApp, QtCore.SLOT('quit()'))

      app = QtGui.QApplication([])
      window = Test()
      window.show()
      sys.exit(app.exec_())
    EOS
    python do
      system python, "test.py"
    end
  end
end
__END__
diff --git a/configure.py b/configure.py
index a8e5dcd..a5f1474 100644
--- a/configure.py
+++ b/configure.py
@@ -1886,7 +1886,7 @@ def get_build_macros(overrides):
     if "QMAKESPEC" in list(os.environ.keys()):
         fname = os.environ["QMAKESPEC"]
 
-        if not os.path.dirname(fname):
+        if not os.path.dirname(fname) or fname.startswith('unsupported'):
             qt_macx_spec = fname
             fname = os.path.join(qt_archdatadir, "mkspecs", fname)
     elif sys.platform == "darwin":
