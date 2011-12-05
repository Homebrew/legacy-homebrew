require 'formula'

class Visualnetkit < Formula
  homepage 'http://code.google.com/p/visual-netkit/'
  url 'http://visual-netkit.googlecode.com/files/visualnetkit-1.4.tar.bz'
  sha1 '17dbc3a6b7e62b1b2183f2a4426b9021781e4ec4'

  depends_on 'qt'

  skip_clean :all

  # We're maintaining a patch to allow this software to compile against newer
  # versions of Qt. Since the upstream project hasn't had activity in a while,
  # if a newer version of Qt breaks this formula we will consider moving it to
  # the boneyard instead.
  def patches
    DATA
  end

  def install
    system "/bin/sh", "./build.sh", "-r"
    inreplace 'bin/visualnetkit.sh', /^APP=.*$/, "APP=#{prefix}"
    prefix.install 'bin/VisualNetkit.app'
    bin.install 'bin/visualnetkit.sh' => 'visualnetkit'
    prefix.install 'bin/plugins'
  end
end

__END__
diff --git a/src/plugin_dev/ipv4/ipv4.pro b/src/plugin_dev/ipv4/ipv4.pro
--- a/src/plugin_dev/ipv4/ipv4.pro
+++ b/src/plugin_dev/ipv4/ipv4.pro
@@ -5,7 +5,7 @@ TEMPLATE = lib
 TARGET = ipv4

 #prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] $$[QMAKE_LFLAGS_SHLIB]
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup $$[QMAKE_LFLAGS_SHLIB]

 DEPENDPATH += .
 DESTDIR = ../../../bin/plugins
diff --git a/src/plugin_dev/mac/mac.pro b/src/plugin_dev/mac/mac.pro
--- a/src/plugin_dev/mac/mac.pro
+++ b/src/plugin_dev/mac/mac.pro
@@ -5,7 +5,7 @@ TEMPLATE = lib
 TARGET = mac

 #prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] $$[QMAKE_LFLAGS_SHLIB]
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup $$[QMAKE_LFLAGS_SHLIB]

 DEPENDPATH += .
 DESTDIR = ../../../bin/plugins
diff --git a/src/plugin_dev/quagga/bgp/quagga-bgp.pro b/src/plugin_dev/quagga/bgp/quagga-bgp.pro
--- a/src/plugin_dev/quagga/bgp/quagga-bgp.pro
+++ b/src/plugin_dev/quagga/bgp/quagga-bgp.pro
@@ -2,7 +2,7 @@ TEMPLATE = lib
 TARGET = quagga-bgp

 # prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] \
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup \
     $$[QMAKE_LFLAGS_SHLIB]
 DEPENDPATH += .
 DESTDIR = ../../../../bin/plugins
diff --git a/src/plugin_dev/quagga/core/quagga-core.pro b/src/plugin_dev/quagga/core/quagga-core.pro
--- a/src/plugin_dev/quagga/core/quagga-core.pro
+++ b/src/plugin_dev/quagga/core/quagga-core.pro
@@ -2,7 +2,7 @@ TEMPLATE = lib
 TARGET = quagga-core

 #prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] $$[QMAKE_LFLAGS_SHLIB]
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup $$[QMAKE_LFLAGS_SHLIB]

 DEPENDPATH += .
 DESTDIR = ../../../../bin/plugins
diff --git a/src/plugin_dev/quagga/rip/quagga-rip.pro b/src/plugin_dev/quagga/rip/quagga-rip.pro
--- a/src/plugin_dev/quagga/rip/quagga-rip.pro
+++ b/src/plugin_dev/quagga/rip/quagga-rip.pro
@@ -2,7 +2,7 @@ TEMPLATE = lib
 TARGET = quagga-rip

 # prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] \
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup \
     $$[QMAKE_LFLAGS_SHLIB]
 DEPENDPATH += .
 DESTDIR = ../../../../bin/plugins
diff --git a/src/plugin_dev/test/test.pro b/src/plugin_dev/test/test.pro
--- a/src/plugin_dev/test/test.pro
+++ b/src/plugin_dev/test/test.pro
@@ -5,7 +5,7 @@ TEMPLATE = lib
 TARGET = test

 #prevent linking error on some system (like ubuntu)
-QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] $$[QMAKE_LFLAGS_SHLIB]
+QMAKE_LFLAGS = -Wl,-rpath,$$[QT_INSTALL_LIBS] -undefined dynamic_lookup $$[QMAKE_LFLAGS_SHLIB]

 DEPENDPATH += .
 DESTDIR = ../../../bin/plugins
diff --git a/bin/visualnetkit.sh b/bin/visualnetkit.sh
--- a/bin/visualnetkit.sh
+++ b/bin/visualnetkit.sh
@@ -6,4 +6,4 @@ APP_PATH=${APP/\/visualnetkit.sh/}

-export VISUAL_NETKIT_PLUGINS="$APP_PATH/plugins:$HOME/.visualnetkit/plugins"
+export VISUAL_NETKIT_PLUGINS="$APP_PATH/../plugins:$HOME/.visualnetkit/plugins"

-$APP_PATH/VisualNetkit
+open $APP_PATH/VisualNetkit.app
diff --git a/src/gui/MainWindow.cpp b/src/gui/MainWindow.cpp
--- a/src/gui/MainWindow.cpp
+++ b/src/gui/MainWindow.cpp
@@ -50,7 +50,8 @@ MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent)
	dockLog->setVisible(false);

	/* init the file dialog (save mode) */
-	saveFileDialog = new QFileDialog(this, tr("Save laboratory as..."), QDir::homePath(), "");
+	saveFileDialog = new QFileDialog(this, Qt::Sheet);
+	saveFileDialog->setDirectory(QDir::home());
	saveFileDialog->setFileMode(QFileDialog::AnyFile);
	saveFileDialog->setAcceptMode(QFileDialog::AcceptSave);
	saveFileDialog->setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
