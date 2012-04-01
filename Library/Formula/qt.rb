require 'formula'

class Qt < Formula
  homepage 'http://qt.nokia.com/'
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.8.0.tar.gz'
  md5 'e8a5fdbeba2927c948d9f477a6abe904'

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.0-bottle.tar.gz'
    sha1 '2bfe00c5112b0d2a680cd01144701f8937846096'
  end

  head 'git://gitorious.org/qt/qt.git', :branch => 'master'

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
    # Fix compilation with llvm-gcc. Remove for 4.8.1.
    [ "https://qt.gitorious.org/qt/qt/commit/448ab?format=patch",
    # Fix Xcode 4 generation. Remove for 4.8.1.
      "https://qt.gitorious.org/qt/qt/commit/b5871?format=patch" ]
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
      mv "../qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      cd "#{prefix}/src"
    else
      args << "-release"
    end

    # Compilation currently fails with the newer versions of clang
    # shipped with Xcode 4.3+
    ENV.llvm if MacOS.clang_version.to_f <= 3.1

    # Needed for Qt 4.8.0 due to attempting to link moc with gcc.
    ENV['LD'] = ENV['CXX']

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
    # TODO - surely this link can be made without the `cd`
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

  def test
    "#{bin}/qmake --version"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
