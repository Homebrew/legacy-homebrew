require 'formula'
require 'hardware'

class Qt <Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.7.1.tar.gz'
  md5 '6f88d96507c84e9fea5bf3a71ebeb6d7'
  homepage 'http://qt.nokia.com/'

  def patches
    # To fix http://bugreports.qt.nokia.com/browse/QTBUG-13623. Patch sent upstream.
    "http://qt.gitorious.org/qt/qt/commit/9f18a1ad5ce32dd397642a4c03fa1fcb21fb9456.patch"
  end

  def options
    [
      ['--with-qtdbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
      ['--with-demos-examples', "Enable Qt demos and examples."],
    ]
  end

  def self.x11?
    File.exist? "/usr/X11R6/lib"
  end

  depends_on "d-bus" if ARGV.include? '--with-qtdbus'
  depends_on 'libpng' unless x11?
  depends_on 'sqlite' if MACOS_VERSION <= 10.5

  def install
    args = ["-prefix", prefix,
            "-system-libpng", "-system-zlib",
            "-release", "-cocoa",
            "-confirm-license", "-opensource",
            "-fast"]

    # See: https://github.com/mxcl/homebrew/issues/issue/744
    args << "-system-sqlite" if MACOS_VERSION <= 10.5
    args << "-plugin-sql-mysql" if (HOMEBREW_CELLAR+"mysql").directory?

    if ARGV.include? '--with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
      args << "-L#{Formula.factory('d-bus').lib}"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if ARGV.include? '--with-qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless ARGV.include? '--with-demos-examples'
      args << "-nomake" << "demos" << "-nomake" << "examples"
    end

    if Qt.x11?
      args << "-L/usr/X11R6/lib"
      args << "-I/usr/X11R6/include"
    else
      args << "-L#{Formula.factory('libpng').lib}"
      args << "-I#{Formula.factory('libpng').include}"
    end

    if snow_leopard_64?
      args << '-arch' << 'x86_64'
    else
      args << '-arch' << 'x86'
    end

    system "./configure", *args
    system "make"
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
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall."
  end
end
