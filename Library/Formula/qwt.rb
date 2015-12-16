class Qwt < Formula
  desc "Qt Widgets for Technical Applications (v5.1)"
  homepage "http://qwt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.2/qwt-6.1.2.tar.bz2"
  sha256 "2b08f18d1d3970e7c3c6096d850f17aea6b54459389731d3ce715d193e243d0c"

  bottle do
    sha256 "b2c5aeab5bb61f3986ec133be41a78dfe6782951c800f84957a2f737c43f1602" => :yosemite
    sha256 "7f297caf1eb539cbe632dd7aad8e1d5a86a697f714e02d786fe5623874be4d76" => :mavericks
    sha256 "07e5a611af760b775ac5e7c405b1d0f20deed6e767045cd07335a09102e42256" => :mountain_lion
  end

  option "with-qwtmathml", "Build the qwtmathml library"
  option "without-plugin", "Skip building the Qt Designer plugin"

  depends_on "qt"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"
      s.sub! /\+(=\s*QwtDesigner)/, "-\\1" if build.without? "plugin"
    end

    args = ["-config", "release", "-spec"]
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      args << "unsupported/macx-clang-libc++"
    else
      args << "macx-g++"
    end

    if build.with? "qwtmathml"
      args << "QWT_CONFIG+=QwtMathML"
      prefix.install "textengines/mathml/qtmmlwidget-license"
    end

    system "qmake", *args
    system "make"
    system "make", "install"

    # symlink Qt Designer plugin (note: not removed on qwt formula uninstall)
    ln_sf prefix/"plugins/designer/libqwt_designer_plugin.dylib",
          Formula["qt"].opt_prefix/"plugins/designer/" if build.with? "plugin"
  end

  def caveats
    if build.with? "qwtmathml"; <<-EOS.undent
        The qwtmathml library contains code of the MML Widget from the Qt solutions package.
        Beside the Qwt license you also have to take care of its license:
        #{opt_prefix}/qtmmlwidget-license
      EOS
    end
  end
end

__END__
diff --git a/designer/designer.pro b/designer/designer.pro
index c269e9d..c2e07ae 100644
--- a/designer/designer.pro
+++ b/designer/designer.pro
@@ -126,6 +126,16 @@ contains(QWT_CONFIG, QwtDesigner) {

     target.path = $${QWT_INSTALL_PLUGINS}
     INSTALLS += target
+
+    macx {
+        contains(QWT_CONFIG, QwtFramework) {
+            QWT_LIB = qwt.framework/Versions/$${QWT_VER_MAJ}/qwt
+        }
+        else {
+            QWT_LIB = libqwt.$${QWT_VER_MAJ}.dylib
+        }
+        QMAKE_POST_LINK = install_name_tool -change $${QWT_LIB} $${QWT_INSTALL_LIBS}/$${QWT_LIB} $(DESTDIR)$(TARGET)
+    }
 }
 else {
     TEMPLATE        = subdirs # do nothing
