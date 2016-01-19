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
  revision 2

  stable do
    url "https://download.qt.io/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
    mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
    sha256 "6f028e63d4992be2b4a5526f2ef3bfa2fe28c5c757554b11d9e8d86189652518"

    # Build error: Fix library detection for QtWebEngine with Xcode 7.
    # https://codereview.qt-project.org/#/c/127759/
    patch do
      url "https://raw.githubusercontent.com/UniqMartin/patches/557a8bd4/qt5/webengine-xcode7.patch"
      sha256 "7bd46f8729fa2c20bc486ddc5586213ccf2fb9d307b3d4e82daa78a2553f59bc"
    end

    # Fix for qmake producing broken pkg-config files, affecting Poppler et al.
    # https://codereview.qt-project.org/#/c/126584/
    # Should land in the 5.5.2 and/or 5.6 release.
    patch do
      url "https://gist.githubusercontent.com/UniqMartin/a54542d666be1983dc83/raw/f235dfb418c3d0d086c3baae520d538bae0b1c70/qtbug-47162.patch"
      sha256 "e31df5d0c5f8a9e738823299cb6ed5f5951314a28d4a4f9f021f423963038432"
    end

    # Build issue: Fix install names with `-no-rpath` to be absolute paths.
    # https://codereview.qt-project.org/#/c/138349
    patch do
      url "https://raw.githubusercontent.com/UniqMartin/patches/77d138fa/qt5/osx-no-rpath.patch"
      sha256 "92c9cfe701f9152f4b16219a04a523338d4b77bb0725a8adccc3fc72c9fb576f"
    end

    # Fixes for Secure Transport in QtWebKit
    # https://codereview.qt-project.org/#/c/139967/
    # https://codereview.qt-project.org/#/c/139968/
    # https://codereview.qt-project.org/#/c/139970/
    # Should land in the 5.5.2 and/or 5.6 release.
    patch do
      url "https://gist.githubusercontent.com/The-Compiler/8202f92fff70da39353a/raw/884c3bef4d272d25d7d7202be99c3940248151ee/qt5.5-securetransport-qtwebkit.patch"
      sha256 "c3302de2e23e74a99e62f22527e0edee5539b2e18d34c05e70075490ba7b3613"
    end
  end

  bottle do
    sha256 "66392beb2f58ca5763c044de0f80128c4d2747b7708dfe749ffa551e323e12e5" => :el_capitan
    sha256 "a7b2d4ef9027f41c0e1f70ecdd39682caa343ac5314eb226e441b30b0943739d" => :yosemite
    sha256 "6a5a3cd1331a217eb2a1abfc09d73d6e06a0ce5cafac9188aee6d96c7fc4ca4e" => :mavericks
  end

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-oci", "Build with Oracle OCI plugin"

  option "without-webengine", "Build without QtWebEngine module"
  option "without-webkit", "Build without QtWebKit module"

  deprecated_option "qtdbus" => "with-d-bus"

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

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

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`. Also add a `-qt5` suffix to
    # avoid conflict with the `*.app` bundles provided by the `qt` formula.
    # (Note: This move/rename breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec/"#{app.basename(".app")}-qt5.app"
    end
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
