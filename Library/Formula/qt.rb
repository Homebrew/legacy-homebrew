require 'formula'

class Qt < Formula
  homepage 'http://qt.nokia.com/'
  url 'http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.2.tar.gz'
  md5 '3c1146ddf56247e16782f96910a8423b'

  bottle do
    sha1 'a634c873a3ce825649c913f5d9ad790397390f74' => :snowleopard
    sha1 'd11c466d3cbc80d3b94431daf481a217bf9097fd' => :lion
  end

  head 'git://gitorious.org/qt/qt.git', :branch => 'master'

  fails_with :clang do
    build 318
  end

  def options
    [
      ['--with-qtdbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
      ['--with-demos-examples', "Enable Qt demos and examples."],
      ['--with-debug-and-release', "Compile Qt in debug and release mode."],
      ['--universal', "Build both x86_64 and x86 architectures."],
      ['--developer', 'Compile and link Qt with Qt developer options']
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
      mv "../qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      cd "#{prefix}/src"
    else
      args << "-release"
    end

    args << '-developer-build' if ARGV.include? '--developer'

    # Needed for Qt 4.8.1 due to attempting to link moc with gcc.
    ENV['LD'] = ENV.cxx

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
