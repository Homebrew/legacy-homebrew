class Pyqt5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.5/PyQt-gpl-5.5.tar.gz"
  sha256 "cdd1bb55b431acdb50e9210af135428a13fb32d7b1ab86e972ac7101f6acd814"
  revision 2

  # Upstream fix for hard-coded dependency on QtDBus module, extracted from the
  # snapshot `PyQt-gpl-5.5.1-snapshot-13f9ece29d02.tar.gz`.
  # Should land in the 5.5.1 release.
  patch :DATA

  bottle do
    sha256 "ce5dbd7dbf9d8377500226050ee1205d979679340443c18612d5d66f3ffb3ee2" => :yosemite
    sha256 "d40d3b90566540600d830931ff7f493ecaac3baf9f723a444116a945d7203660" => :mavericks
    sha256 "9f07294fb874a412a62f93f90382d22a1177f29c589c2b7bf331974b7656d952" => :mountain_lion
  end

  option "enable-debug", "Build with debug symbols"
  option "with-docs", "Install HTML documentation and python examples"

  depends_on :python3 => :recommended
  depends_on :python => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt5: --with-python3 must be specified when using --without-python"
  end

  depends_on "qt5"

  if build.with? "python3"
    depends_on "sip" => "with-python3"
  else
    depends_on "sip"
  end

  def install
    Language::Python.each_python(build) do |python, version|
      args = ["--confirm-license",
              "--bindir=#{bin}",
              "--destdir=#{lib}/python#{version}/site-packages",
              # To avoid conflicts with PyQt (for Qt4):
              "--sipdir=#{share}/sip/Qt5/",
              # sip.h could not be found automatically
              "--sip-incdir=#{Formula["sip"].opt_include}",
              # Make sure the qt5 version of qmake is found.
              # If qt4 is linked it will pickup that version otherwise.
              "--qmake=#{Formula["qt5"].bin}/qmake",
              # Force deployment target to avoid libc++ issues
              "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
              "--qml-plugindir=#{pkgshare}/plugins",
              "--verbose"]
      args << "--debug" if build.include? "enable-debug"

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"
    end
    doc.install "doc/html", "examples" if build.with? "docs"
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import PyQt5"
      %w[
        Gui
        Location
        Multimedia
        Network
        Quick
        Svg
        WebKit
        Widgets
        Xml
      ].each { |mod| system python, "-c", "import PyQt5.Qt#{mod}" }
    end
  end
end

__END__
diff --git 1/configure.py 2/configure.py
index 2144c2e3..8aa4226a 100644
--- 1/configure.py
+++ 2/configure.py
@@ -2478,9 +2504,25 @@ win32 {
         pro_lines.append('LIBS += %s' % libs)

     if not target_config.static:
-        # Make sure these frameworks are already loaded by the time the
-        # libqcocoa.dylib plugin gets loaded.
-        extra_lflags = 'QMAKE_LFLAGS += "-framework QtPrintSupport -framework QtDBus -framework QtWidgets"\n        ' if mname == 'QtGui' else ''
+        # For Qt v5.5 and later, Make sure these frameworks are already loaded
+        # by the time the libqcocoa.dylib plugin gets loaded.  This problem is
+        # due to be fixed in Qt v5.6.
+        extra_lflags = ''
+
+        if mname == 'QtGui':
+            # Note that this workaround is flawed because it looks at the PyQt
+            # configuration rather than the Qt configuration.  It will fail if
+            # the user is building a PyQt without the QtDBus module against a
+            # Qt with the QtDBus library.  However it will be fine for the
+            # common case where the PyQt configuration reflects the Qt
+            # configuration.
+            fwks = []
+            for m in ('QtPrintSupport', 'QtDBus', 'QtWidgets'):
+                if m in target_config.pyqt_modules:
+                    fwks.append('-framework ' + m)
+
+            if len(fwks) != 0:
+                extra_lflags = 'QMAKE_LFLAGS += "%s"\n        ' % ' '.join(fwks)

         shared = '''
 win32 {
