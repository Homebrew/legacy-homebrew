require 'formula'

class Qt5 < Formula
  homepage 'http://qt-project.org/'
  url 'http://releases.qt-project.org/qt5/5.0.1/single/qt-everywhere-opensource-src-5.0.1.tar.gz'
  sha1 'fda04435b1d4069dc189ab4d22ed7a36fe6fa3e9'

  head 'git://gitorious.org/qt/qt5.git', :branch => 'master'

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-demos-examples', 'Enable Qt demos and examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'with-mysql', 'Enable MySQL plugin'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on :libpng

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on "mysql" if build.include? 'with-mysql'
  depends_on "jpeg"

  def patches
    # http://qt.gitorious.org/qt/qtbase/commit/655ba5?format=patch
    # Inlined to fix paths.
    DATA
  end

  def install
    args = ["-prefix", prefix,
            "-system-libpng", "-system-zlib",
            "-confirm-license", "-opensource"]

    unless MacOS::CLT.installed?
      # Qt hard-codes paths (and uses -I flags) and linking fails on Xcode-only
      args += ["-sdk", MacOS.sdk_path]
      # Even with sdk given, Qt5 is too stupid to find CFNumber.h, so we give a hint:
      ENV.append 'CXXFLAGS', "-I#{MacOS.sdk_path}/System/Library/Frameworks/CoreFoundation.framework/Headers"
    end

    args << "-L#{MacOS::X11.prefix}/lib" << "-I#{MacOS::X11.prefix}/include" if MacOS::X11.installed?

    args << "-plugin-sql-mysql" if build.include? 'with-mysql'

    if build.include? 'with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
    end

    unless build.include? 'with-demos-examples'
      args << "-nomake" << "demos" << "-nomake" << "examples"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    if build.include? 'with-debug-and-release'
      args << "-debug-and-release"
      # Debug symbols need to find the source so build in the prefix
      mv "../qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      cd "#{prefix}/src"
    else
      args << "-release"
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree

    # Some config scripts will only find Qt in a "Frameworks" folder
    # VirtualBox is an example of where this is needed
    # See: https://github.com/mxcl/homebrew/issues/issue/745
    cd prefix do
      ln_s lib, prefix + "Frameworks"
    end

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end

    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
  end

  def test
    system "#{bin}/qmake", "--version"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end

__END__
From 655ba5755696df8e2594bca9f7696ab621f5afc3 Mon Sep 17 00:00:00 2001
From: Gabriel de Dietrich <gabriel.dedietrich@digia.com>
Date: Tue, 5 Feb 2013 13:39:33 +0100
Subject: [PATCH] Cocoa QPA: Fix compilation error

The error appeared with latest clang as of Feb. 5, 2013.

Apple LLVM version 4.2 (clang-425.0.24) (based on LLVM 3.2svn)
Target: x86_64-apple-darwin12.2.0

Change-Id: I8df8cccc941ac03a7a997bdd5afe095b7b6f65d3
Reviewed-by: Frederik Gladhorn <frederik.gladhorn@digia.com>
---
 src/plugins/platforms/cocoa/qcocoawindow.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h b/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
index 3b5be0a..324a43c 100644
--- a/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
+++ b/qtbase/src/plugins/platforms/cocoa/qcocoawindow.h
@@ -49,7 +49,8 @@

 #include "qcocoaglcontext.h"
 #include "qnsview.h"
-class QT_PREPEND_NAMESPACE(QCocoaWindow);
+
+QT_FORWARD_DECLARE_CLASS(QCocoaWindow)

 @interface QNSWindow : NSWindow {
     @public QCocoaWindow *m_cocoaPlatformWindow;
--
1.7.1
