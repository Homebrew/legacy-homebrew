require 'formula'

class Qt5 < Formula
  homepage 'http://qt-project.org/'
  url 'http://releases.qt-project.org/qt5/5.0.0/single/qt-everywhere-opensource-src-5.0.0.tar.gz'
  sha1 '42f4b11389fe1361352cdd04f258f0d6f175ebfd'

  head 'git://gitorious.org/qt/qt5.git', :branch => 'master'

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  fails_with :clang do
    build 425
  end

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-demos-examples', 'Enable Qt demos and examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'with-mysql', 'Enable MySQL plugin'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on :libpng

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on "mysql" if build.include? 'with-mysql'

  def install
    args = ["-prefix", prefix,
            "-system-libpng", "-system-zlib",
            "-confirm-license", "-opensource",
            "-fast" ]

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
