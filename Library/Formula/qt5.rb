require 'formula'

class Qt5HeadDownloadStrategy < GitDownloadStrategy
  include FileUtils

  def stage
    @clone.cd { reset }
    safe_system 'git', 'clone', @clone, '.'
    ln_s @clone, 'qt'
    safe_system './init-repository', '--mirror', "#{Dir.pwd}/"
    rm 'qt'
  end
end

class Qt5 < Formula
  homepage 'http://qt-project.org/'
  url 'http://download.qt-project.org/official_releases/qt/5.2/5.2.1/single/qt-everywhere-opensource-src-5.2.1.tar.gz'
  sha1 '31a5cf175bb94dbde3b52780d3be802cbeb19d65'

  bottle do
    revision 2
    sha1 "6a514fbf56491a64316ef05acdf07ca6526ba458" => :mavericks
    sha1 "2518707b0ad69462a620fcd5c2e482053a239914" => :mountain_lion
    sha1 "b2362eb20666b961d1d2acec629e4a581aa2b87a" => :lion
  end

  head 'git://gitorious.org/qt/qt5.git', :branch => 'stable',
    :using => Qt5HeadDownloadStrategy, :shallow => false

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "pkg-config" => :build
  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional

  odie 'qt5: --with-qtdbus has been renamed to --with-d-bus' if build.with? "qtdbus"
  odie 'qt5: --with-demos-examples is no longer supported' if build.with? "demos-examples"
  odie 'qt5: --with-debug-and-release is no longer supported' if build.with? "debug-and-release"

  def install
    # fixed hardcoded link to plugin dir: https://bugreports.qt-project.org/browse/QTBUG-29188
    inreplace "qttools/src/macdeployqt/macdeployqt/main.cpp", "deploymentInfo.pluginPath = \"/Developer/Applications/Qt/plugins\";",
              "deploymentInfo.pluginPath = \"#{prefix}/plugins\";"

    ENV.universal_binary if build.universal?
    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "examples",
            "-nomake", "tests",
            "-release"]

    unless MacOS::CLT.installed?
      # ... too stupid to find CFNumber.h, so we give a hint:
      ENV.append 'CXXFLAGS', "-I#{MacOS.sdk_path}/System/Library/Frameworks/CoreFoundation.framework/Headers"
    end

    # https://bugreports.qt-project.org/browse/QTBUG-34382
    args << "-no-xcb"

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    args << "-plugin-sql-mysql" if build.with? 'mysql'

    if build.with? 'd-bus'
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"
    if build.with? 'docs'
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

    # configure saved the PKG_CONFIG_LIBDIR set up by superenv; remove it
    # see: https://github.com/Homebrew/homebrew/issues/27184
    inreplace prefix/"mkspecs/qconfig.pri", /\n\n# pkgconfig/, ""
    inreplace prefix/"mkspecs/qconfig.pri", /\nPKG_CONFIG_.*=.*$/, ""

    Pathname.glob("#{bin}/*.app") { |app| mv app, prefix }
  end

  test do
    system "#{bin}/qmake", "-project"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
