require 'formula'
require 'hardware'

class Qt < Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.7.3.tar.gz'
  md5 '49b96eefb1224cc529af6fe5608654fe'
  homepage 'http://qt.nokia.com/'

  def options
    [
      ['--with-qtdbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
      ['--with-demos-examples', "Enable Qt demos and examples."],
      ['--with-debug-and-release', "Compile Qt in debug and release mode."],
      ['--universal', "Build both x86_64 and x86 architectures."],
    ]
  end

  depends_on "d-bus" if ARGV.include? '--with-qtdbus'
  depends_on 'sqlite' if MacOS.leopard?

  def patches
    # Replaces calls to super in error condition with proper error values.
    # super does not implement those methods (derp)
    DATA
  end

  def install
    ENV.x11
    ENV.append "CXXFLAGS", "-fvisibility=hidden"
    args = ["-prefix", prefix,
            "-system-libpng", "-system-zlib",
            "-L/usr/X11/lib", "-I/usr/X11/include",
            "-confirm-license", "-opensource",
            "-cocoa", "-fast" ]

    # See: https://github.com/mxcl/homebrew/issues/issue/744
    args << "-system-sqlite" if MacOS.leopard?
    args << "-plugin-sql-mysql" if (HOMEBREW_CELLAR+"mysql").directory?

    if ARGV.include? '--with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
    end

    if ARGV.include? '--with-qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless ARGV.include? '--with-demos-examples'
      args << "-nomake" << "demos" << "-nomake" << "examples"
    end

    if MacOS.prefer_64_bit? or ARGV.build_universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or ARGV.build_universal?
      args << '-arch' << 'x86'
    end

    if ARGV.include? '--with-debug-and-release'
      args << "-debug-and-release"
      # Debug symbols need to find the source so build in the prefix
      Dir.chdir '..'
      mv "qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      Dir.chdir "#{prefix}/src"
    else
      args << "-release"
    end

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # stop crazy disk usage
    (prefix+'doc/html').rmtree
    (prefix+'doc/src').rmtree
    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink

    # Some config scripts will only find Qt in a "Frameworks" folder
    # VirtualBox is an example of where this is needed
    # See: https://github.com/mxcl/homebrew/issues/issue/745
    cd prefix do
      ln_s lib, "Frameworks"
    end
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall."
  end
end

__END__
diff --git a/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h b/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
index 8ef5f98..bd8691e 100644
--- a/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
+++ b/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
@@ -309,7 +309,7 @@ QT_END_NAMESPACE
 
     QWidget *target = [self dragTargetHitTest:sender];
     if (!target)
-        return [super draggingEntered:sender];
+        return NSDragOperationNone;
     if (target->testAttribute(Qt::WA_DropSiteRegistered) == false)
         return NSDragOperationNone;
 
@@ -321,7 +321,7 @@ QT_END_NAMESPACE
 {
     QWidget *target = [self dragTargetHitTest:sender];
     if (!target)
-        return [super draggingUpdated:sender];
+        return NSDragOperationNone;
 
     if (target == *currentDragTarget()) {
         // The drag continues to move over the widget that we have sendt
@@ -345,7 +345,7 @@ QT_END_NAMESPACE
 {
     QWidget *target = [self dragTargetHitTest:sender];
     if (!target)
-        return [super draggingExited:sender];
+        return;
 
     if (*currentDragTarget()) {
         [reinterpret_cast<NSView *>((*currentDragTarget())->winId()) draggingExited:sender];
@@ -357,7 +357,7 @@ QT_END_NAMESPACE
 {
     QWidget *target = [self dragTargetHitTest:sender];
     if (!target)
-        return [super performDragOperation:sender];
+        return NO;
 
     BOOL dropResult = NO;
     if (*currentDragTarget()) {