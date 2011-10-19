require 'formula'
require 'hardware'

class Qt < Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.7.4.tar.gz'
  md5 '9831cf1dfa8d0689a06c2c54c5c65aaf'
  homepage 'http://qt.nokia.com/'
  bottle 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.7.4-bottle.tar.gz'
  bottle_sha1 '3195cddb76c0d13b4500dc75cc55f20f00c10ef1'

  head 'git://gitorious.org/qt/qt.git', :branch => 'master'

  def patches
    [
      # Stop complaining about using Lion
      "https://qt.gitorious.org/qt/qt/commit/1766bbdb53e1e20a1bbfb523bbbbe38ea7ab7b3d?format=patch",
      # Fixes typo in WebKit, this can be removed when upgrading to Qt 4.8
      # see https://bugs.webkit.org/show_bug.cgi?id=47284 for details
      DATA
    ]
  end

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

    # The pkg-config files installed suggest that geaders can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end

__END__
diff --git a/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandlePrivate.h b/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandlePrivate.h
index 235f1b1..d074f42 100644
--- a/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandlePrivate.h
+++ b/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandlePrivate.h
@@ -57 +57 @@ public slots:
-    void socketSentdata();
+    void socketSentData();
diff --git a/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandleQt.cpp b/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandleQt.cpp
index e666ff7..d7a7fcc 100644
--- a/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandleQt.cpp
+++ b/src/3rdparty/webkit/WebCore/platform/network/qt/SocketStreamHandleQt.cpp
@@ -113 +113 @@ void SocketStreamHandlePrivate::close()
-void SocketStreamHandlePrivate::socketSentdata()
+void SocketStreamHandlePrivate::socketSentData()
