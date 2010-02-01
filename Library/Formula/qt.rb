require 'formula'
require 'hardware'

class Qt <Formula
  url 'http://get.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.1.tar.gz'
  md5 '2a7b5126f2450d8525af355fc4c12ad6'
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

  def install
    if version == '4.6.1' # being specific so needs reconfirmed each version
      # Bug reported here: http://bugreports.qt.nokia.com/browse/QTBUG-7630
      makefiles=%w[plugins/sqldrivers/sqlite/sqlite.pro 3rdparty/webkit/WebCore/WebCore.pro]
      makefiles.each { |makefile| `echo 'LIBS += -lsqlite3' >> src/#{makefile}` }
    end

    conf_args = ["-prefix", prefix,
                 "-system-sqlite", "-system-libpng", "-system-zlib",
                 "-nomake", "demos", "-nomake", "examples",
                 "-release", "-cocoa",
                 "-confirm-license", "-opensource",
                 "-fast"]

    conf_args << "-plugin-sql-mysql" if (HOMEBREW_CELLAR+"mysql").directory?

    if ARGV.include? '--with-qtdbus'
      conf_args << "-I#{Formula.factory('dbus').lib}/dbus-1.0/include"
      conf_args << "-I#{Formula.factory('dbus').include}/dbus-1.0"
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

    # remove unneeded files
    `find #{lib} -name \*.prl -delete`
    # stop crazy disk usage
    (prefix+'doc'+'html').rmtree
    (prefix+'doc'+'src').rmtree
    # what are these anyway?
    (bin+'Assistant_adp.app').rmtree
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove debugging files that slipped through
    (lib+'libQtUiTools_debug.a').unlink
    (lib+'pkgconfig/QtUiTools_debug.pc').unlink
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall."
  end
end
