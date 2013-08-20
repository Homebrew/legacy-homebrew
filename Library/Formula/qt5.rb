require 'formula'

class Qt5 < Formula
  homepage 'http://qt-project.org/'
  url 'http://download.qt-project.org/official_releases/qt/5.1/5.1.0/single/qt-everywhere-opensource-src-5.1.0.tar.gz'
  sha1 '12d706124dbfac3d542dd3165176a978d478c085'

  bottle do
    revision 1
    sha1 '559797c1240c758aea1755b664fb898d492fca03' => :mountain_lion
    sha1 '67d969a4a260f4576f3fcaf5e1cef23edfd35177' => :lion
    sha1 '61cfa853784d2493ffa00b3e2897f6f46df5815f' => :snow_leopard
  end

  head 'git://gitorious.org/qt/qt5.git', :branch => 'stable'

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-demos-examples', 'Enable Qt demos and examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'with-mysql', 'Enable MySQL plugin'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on "mysql" => :optional

  def install
    ENV.universal_binary if build.universal?
    args = ["-prefix", prefix,
            "-system-zlib",
            "-confirm-license", "-opensource"]

    unless MacOS::CLT.installed?
      # ... too stupid to find CFNumber.h, so we give a hint:
      ENV.append 'CXXFLAGS', "-I#{MacOS.sdk_path}/System/Library/Frameworks/CoreFoundation.framework/Headers"
    end

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    args << "-plugin-sql-mysql" if build.with? 'mysql'

    if build.with? 'qtdbus'
      dbus_opt = Formula.factory('d-bus').opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
    end

    unless build.include? 'with-demos-examples'
      args << "-nomake" << "examples"
      # In latest head `-nomake demos` is no longer recognized
      args << "-nomake" << "demos" unless build.head?
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    if build.include? 'with-debug-and-release'
      args << "-debug-and-release"
    else
      args << "-release"
    end

    args << '-developer-build' if build.include? 'developer'

    # We move the source and build in-place because:
    # - Debug symbols need to find the source
    # - to fix https://github.com/mxcl/homebrew/issues/20020
    # - PySide `make apidoc` needs the src
    (prefix/"src").mkdir
    mv Dir['*'], "#{prefix}/src/"
    cd "#{prefix}/src"

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # Fix https://github.com/mxcl/homebrew/issues/20020 (upstream: https://bugreports.qt-project.org/browse/QTBUG-32417)
    system "install_name_tool", "-change", "#{pwd}/qt-everywhere-opensource-src-5.1.0/qtwebkit/lib/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets", #old
                                           "#{lib}/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets",  #new
                                           "#{libexec}/QtWebProcess" # in this lib
    system "install_name_tool", "-change", "#{pwd}/qt-everywhere-opensource-src-5.1.0/qtwebkit/lib/QtWebKit.framework/Versions/5/QtWebKit",
                                           "#{lib}/QtWebKit.framework/Versions/5/QtWebKit",
                                           "#{prefix}/qml/QtWebKit/libqmlwebkitplugin.dylib"

    # Some config scripts will only find Qt in a "Frameworks" folder
    cd prefix do
      ln_s lib, frameworks
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

  test do
    system "#{bin}/qmake", "--version"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
