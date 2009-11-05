require 'formula'

class Qt <Formula
  url 'http://get.qt.nokia.com/qt/source/qt-mac-opensource-src-4.5.3.tar.gz'
  md5 '484e3739fdc51540218ed92f4b732881'
  homepage 'http://www.qtsoftware.com'

  def patches
    # Give the option to use Qt3Support even when using Cocoa.
    "http://qt.gitorious.org/+qt-iphone/qt/qt-iphone-clone/commit/106d7a210be1e6d52946b575a262e2c76c5e51e6.patch"
  end

  def options
    [
      ['--with-dbus', "Enable QtDBus module."],
      ['--with-qt3support', "Enable deprecated Qt3Support module."],
    ]
  end

  if ARGV.include? '--with-dbus'
    depends_on "dbus"
  end

  if ARGV.include? '--with-qt3support'
    depends_on "dbus"
  end

  if not File.exist? "/usr/X11R6/lib"
    depends_on 'libpng'
  end

  def install
    if version == '4.5.3'
      # Reported 6 months ago (at 4.5.0-rc1), still not fixed in the this release! :(
      makefiles=%w[plugins/sqldrivers/sqlite/sqlite.pro 3rdparty/webkit/WebCore/WebCore.pro]
      makefiles.each { |makefile| `echo 'LIBS += -lsqlite3' >> src/#{makefile}` }
    end

    conf_args = ["-prefix", prefix,
                 "-system-sqlite", "-system-libpng", "-system-zlib",
                 "-nomake", "demos", "-nomake", "examples",
                 "-release", "-cocoa",
                 "-confirm-license", "-opensource",
                 "-fast"]

    if ARGV.include? '--with-dbus'
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

    if File.exist? "/usr/X11R6/lib"
      conf_args << "-L/usr/X11R6/lib"
      conf_args << "-I/usr/X11R6/include"
    else
      conf_args << "-L#{Formula.factory('libpng').lib}"
      conf_args << "-I#{Formula.factory('libpng').include}"
    end

    if MACOS_VERSION >= 10.6
      conf_args << '-arch' << 'x86_64'
    else
      conf_args << '-arch' << 'x86'
    end
    
    system "./configure", *conf_args
    system "make install"

    # fuck weird prl files
    `find #{lib} -name \*.prl -delete`
    # fuck crazy disk usage
    `rm -r #{prefix+'doc'+'html'} #{prefix+'doc'+'src'}`
    # wtf are these anyway?
    `rm -r #{bin}/Assistant_adp.app #{bin}/pixeltool.app #{bin}/qhelpconverter.app`
    # we specified no debug already! :P
    `rm #{lib}/libQtUiTools_debug.a #{lib}/pkgconfig/QtUiTools_debug.pc`
    # meh
    `rm #{prefix}/q3porting.xml`
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall :P"
  end
end
