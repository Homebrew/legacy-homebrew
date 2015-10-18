class OracleHomeVarRequirement < Requirement
  fatal true
  satisfy(:build_env => false) { ENV["ORACLE_HOME"] }

  def message; <<-EOS.undent
      To use --with-oci you have to set the ORACLE_HOME environment variable.
      Check Oracle Instant Client documentation for more information.
    EOS
  end
end

# Patches for Qt5 must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt5 < Formula
  desc "Version 5 of the Qt framework"
  homepage "https://www.qt.io/"
  head "https://code.qt.io/qt/qt5.git", :branch => "5.5", :shallow => false

  stable do
    url "https://download.qt.io/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
    mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
    sha256 "6f028e63d4992be2b4a5526f2ef3bfa2fe28c5c757554b11d9e8d86189652518"

    # Build error: Fix library paths with Xcode 7 for QtWebEngine.
    # https://codereview.qt-project.org/#/c/122729/
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/2fcc1f8ec1df1c90785f4fa6632cebac68772fa9/qt5/el-capitan-2.diff"
      sha256 "b8f04efd047eeed7cfd15b029ece20b5fe3c0960b74f7a5cb98bd36475463227"
    end

    # Fix for qmake producing broken pkg-config files, affecting Poppler et al.
    # https://codereview.qt-project.org/#/c/126584/
    # Should land in the 5.5.2 and/or 5.6 release.
    patch do
      url "https://gist.githubusercontent.com/UniqMartin/a54542d666be1983dc83/raw/f235dfb418c3d0d086c3baae520d538bae0b1c70/qtbug-47162.patch"
      sha256 "e31df5d0c5f8a9e738823299cb6ed5f5951314a28d4a4f9f021f423963038432"
    end
  end

  bottle do
    sha256 "ea7a6528da501b0d51b50f1ca246d9054727d31dcc2875b1b1ab651ffd5034c3" => :el_capitan
    sha256 "22488cddd5e6c0ba017b3d4809c44a94e8fb0956876c6a391edb368f4137abe1" => :yosemite
    sha256 "d5a45faaf3a7b6e40bf202d9ab796ca57008964dbbf78ea2bb9d5dea9f0f6fa8" => :mavericks
  end

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-developer", "Build and link with developer options"
  option "with-oci", "Build with Oracle OCI plugin"

  option "without-webengine", "Build without QtWebEngine module"
  option "without-webkit", "Build without QtWebKit module"

  deprecated_option "developer" => "with-developer"
  deprecated_option "qtdbus" => "with-d-bus"

  # Snow Leopard is untested and support has been removed in 5.4
  # https://qt.gitorious.org/qt/qtbase/commit/5be81925d7be19dd0f1022c3cfaa9c88624b1f08
  depends_on :macos => :lion
  depends_on "d-bus" => :optional
  depends_on :mysql => :optional
  depends_on :xcode => :build

  depends_on OracleHomeVarRequirement if build.with? "oci"

  def install
    args = %W[
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -no-openssl -securetransport
      -nomake tests
      -no-rpath
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    args << "-plugin-sql-mysql" if build.with? "mysql"

    if build.with? "d-bus"
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    else
      args << "-no-dbus"
    end

    if build.with? "oci"
      args << "-I#{ENV["ORACLE_HOME"]}/sdk/include"
      args << "-L#{ENV["ORACLE_HOME"]}"
      args << "-plugin-sql-oci"
    end

    args << "-skip" << "qtwebengine" if build.without? "webengine"
    args << "-skip" << "qtwebkit" if build.without? "webkit"

    args << "-developer-build" if build.with? "developer"

    system "./configure", *args
    system "make"
    ENV.j1
    system "make", "install"

    if build.with? "docs"
      system "make", "docs"
      system "make", "install_docs"
    end

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # configure saved PKG_CONFIG_LIBDIR set up by superenv; remove it
    # see: https://github.com/Homebrew/homebrew/issues/27184
    inreplace prefix/"mkspecs/qconfig.pri", /\n\n# pkgconfig/, ""
    inreplace prefix/"mkspecs/qconfig.pri", /\nPKG_CONFIG_.*=.*$/, ""

    Pathname.glob("#{bin}/*.app") { |app| mv app, prefix }
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<-EOS.undent
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<-EOS.undent
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert File.exist?("hello")
    assert File.exist?("main.o")
    system "./hello"
  end
end
