require 'brewkit'

class Qt <Formula
  @url='http://get.qt.nokia.com/qt/source/qt-mac-opensource-src-4.5.2.tar.gz'
  @md5='c549d6c0c2e0723377cb955c78a1b680'
  @homepage='http://www.qtsoftware.com'

  def install
    if version == '4.5.2'
      # Reported 6 months ago (at 4.5.0-rc1), still not fixed in the this release! :(
      makefiles=%w[plugins/sqldrivers/sqlite/sqlite.pro 3rdparty/webkit/WebCore/WebCore.pro]
      makefiles.each { |makefile| `echo 'LIBS += -lsqlite3' >> src/#{makefile}` }
    end

    system "./configure", "-prefix", prefix,
                        "-system-sqlite", "-system-libpng", "-system-zlib",
                        "-nomake", "demos", "-nomake", "examples", "-no-qt3support",
                        "-release", "-cocoa", "-arch x86",
                        "-confirm-license", "-opensource",
                        "-I/usr/X11R6/include", "-L/usr/X11R6/lib",
                        "-fast"
    system "make install"

    # fuck weird prl files
    `find #{lib} -name \*.prl -delete`
    # fuck crazy disk usage
    `rm -r #{prefix+'doc'+'html'} #{prefix+'doc'+'src'}`
    # wtf are these anyway?
    `rm -r #{bin}/Assistant_adp.app #{bin}/pixeltool.app #{bin}/qhelpconverter.app`
    # we specified no debug already! :P
    `rm #{lib}/libQtUiTools_debug.a`
    # meh
    `rm #{prefix}/q3porting.xml`
  end

  def caveats
    "We agreed to the Qt opensource license for you.\nIf this is unacceptable you should uninstall :P"
  end
end
