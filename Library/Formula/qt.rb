require 'formula'

class Qt < Formula
  homepage 'http://qt-project.org/'
  url 'http://download.qt-project.org/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz'
  sha1 '745f9ebf091696c0d5403ce691dc28c039d77b9e'

  bottle do
    revision 1
    sha1 '7f1901dfac85006e37599a87b4e703fe461bdc54' => :mountain_lion
    sha1 '6ad69314c99323a5ad13e25f46c2c4d5f23dcfa4' => :lion
    sha1 '9501177ed38218f500eee8f1eb7d2ae00e4993c4' => :snow_leopard
  end

  head 'git://gitorious.org/qt/qt.git', :branch => '4.8'

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-qt3support', 'Enable deprecated Qt3Support module'
  option 'with-demos-examples', 'Enable Qt demos and examples'
  option 'with-docs', 'Build Qt documentation'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on "d-bus" if build.with? 'qtdbus'
  depends_on "mysql" => :optional

  def install
    ENV.universal_binary if build.universal?
    ENV.append "CXXFLAGS", "-fvisibility=hidden"

    args = ["-prefix", prefix,
            "-system-zlib",
            "-confirm-license", "-opensource",
            "-cocoa", "-fast" ]

    # we have to disable these to avoid triggering optimization code
    # that will fail in superenv, perhaps because we rename clang to cc and
    # Qt thinks it can build with special assembler commands.
    # In --env=std, Qt seems aware of this.)
    # But we want superenv, because it allows to build Qt in non-standard
    # locations and with Xcode-only.
    args << "-no-3dnow" << "-no-ssse3" if superenv?

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    args << "-platform" << "unsupported/macx-clang" if ENV.compiler == :clang

    args << "-plugin-sql-mysql" if build.with? 'mysql'

    if build.with? 'qtdbus'
      dbus_opt = Formula.factory('d-bus').opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
    end

    if build.with? 'qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless build.with? 'demos-examples'
      args << "-nomake" << "demos" << "-nomake" << "examples"
    end

    unless build.with? 'docs'
      args << "-nomake" << "docs"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    # We move the source and build in-place because:
    # - Debug symbols need to find the source so build in the prefix
    # - to fix https://github.com/mxcl/homebrew/issues/20020
    # - PySide `make apidoc` needs the src
    (prefix/"src").mkdir
    mv Dir['*'], "#{prefix}/src/"
    cd "#{prefix}/src"

    if build.with? 'debug-and-release'
      args << "-debug-and-release"
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
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink if build.without? 'qt3support'

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.mkpath
    ln_s Dir['lib/*.framework'], frameworks

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
    system "#{bin}/qmake", '-project'
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
