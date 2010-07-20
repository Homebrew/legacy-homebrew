require 'formula'
require 'hardware'

class Qt <Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.3.tar.gz'
  md5 '5c69f16d452b0bb3d44bc3c10556c072'
  homepage 'http://www.qtsoftware.com'

  def options
    [
      ['--with-qtdbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
    ]
  end
  
  def self.x11?
    File.exist? "/usr/X11R6/lib"
  end

  depends_on "d-bus" if ARGV.include? '--with-qtdbus'
  depends_on 'libpng' unless x11?
  depends_on 'sqlite' if MACOS_VERSION <= 10.5

  def install
    conf_args = ["-prefix", prefix,
                 "-system-libpng", "-system-zlib",
                 "-nomake", "demos", "-nomake", "examples",
                 "-release", "-cocoa",
                 "-confirm-license", "-opensource",
                 "-fast"]

    # See: http://github.com/mxcl/homebrew/issues/issue/744
    conf_args << "-system-sqlite" if MACOS_VERSION <= 10.5

    conf_args << "-plugin-sql-mysql" if (HOMEBREW_CELLAR+"mysql").directory?

    if ARGV.include? '--with-qtdbus'
      conf_args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      conf_args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
      conf_args << "-L#{Formula.factory('d-bus').lib}"
      conf_args << "-ldbus-1"
      conf_args << "-dbus-linked"
    end

    if ARGV.include? '--with-qt3support'
      conf_args << "-qt3support"
    else
      conf_args << "-no-qt3support"
    end

    if Qt.x11?
      conf_args << "-L/usr/X11R6/lib"
      conf_args << "-I/usr/X11R6/include"
    else
      conf_args << "-L#{Formula.factory('libpng').lib}"
      conf_args << "-I#{Formula.factory('libpng').include}"
    end

    if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
      conf_args << '-arch' << 'x86_64'
    else
      conf_args << '-arch' << 'x86'
    end
    
    system "./configure", *conf_args
    system "make install"

    # stop crazy disk usage
    (prefix+'doc/html').rmtree
    (prefix+'doc/src').rmtree
    # what are these anyway?
    (bin+'Assistant_adp.app').rmtree
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink
    
    # Some config scripts will only find Qt in a "Frameworks" folder
    # VirtualBox is an example of where this is needed
    # See: http://github.com/mxcl/homebrew/issues/issue/745
    cd prefix do
      ln_s lib, "Frameworks"
    end
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall."
  end
end
