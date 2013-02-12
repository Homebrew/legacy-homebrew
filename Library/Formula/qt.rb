require 'formula'

class Qt < Formula
  homepage 'http://qt-project.org/'
  url 'http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.4.tar.gz'
  sha1 'f5880f11c139d7d8d01ecb8d874535f7d9553198'

  bottle do
    sha1 'a5f5efa78a682bf59ae9458b89a17513e912d272' => :mountainlion
    sha1 'ae790ff205b90867f11c598d6e1f1b2a141fce14' => :lion
    sha1 '4ad517d67b35668fb0f18d10ddff323de4ba6840' => :snowleopard
  end

  head 'git://gitorious.org/qt/qt.git', :branch => 'master'

  env :std # Otherwise fails on SSE intrinsics

  fails_with :clang do
    build 425
  end

  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-qt3support', 'Enable deprecated Qt3Support module'
  option 'with-demos-examples', 'Enable Qt demos and examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'with-mysql', 'Enable MySQL plugin'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on :libpng

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on "mysql" if build.include? 'with-mysql'
  depends_on 'sqlite' if MacOS.version == :leopard

  def patches
    # Fixes compilation failure on Leopard.
    # https://bugreports.qt-project.org/browse/QTBUG-23258
    if MacOS.version == :leopard
      "http://bugreports.qt-project.org/secure/attachment/26712/Patch-Qt-4.8-for-10.5"
    end
  end

  def install
    ENV.append "CXXFLAGS", "-fvisibility=hidden"
    args = ["-prefix", prefix,
            "-system-libpng", "-system-zlib",
            "-confirm-license", "-opensource",
            "-cocoa", "-fast" ]

    args << "-L#{MacOS::X11.prefix}/lib" << "-I#{MacOS::X11.prefix}/include" if MacOS::X11.installed?

    args << "-platform" << "unsupported/macx-clang" if ENV.compiler == :clang

    # See: https://github.com/mxcl/homebrew/issues/issue/744
    args << "-system-sqlite" if MacOS.version == :leopard

    args << "-plugin-sql-mysql" if build.include? 'with-mysql'

    if build.include? 'with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
    end

    if build.include? 'with-qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
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
