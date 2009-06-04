require 'brewkit'

class Qt <Formula
  @url='http://get.qtsoftware.com/qt/source/qt-mac-opensource-src-4.5.1.tar.gz'
  @md5='9fc0e96197df6db48a0628ac4d63e0dd'
  @homepage='http://www.qtsoftware.com'

  def install
    if version == '4.5.1'
      # Reported 6 months ago (at 4.5.0-rc1), still not fixed in the this release! :(
      makefiles=['plugins/sqldrivers/sqlite/sqlite.pro', '3rdparty/webkit/WebCore/WebCore.pro']
      makefiles.each { |makefile| `echo 'LIBS += -lsqlite3' >> src/#{makefile}` }
    end

    configure=<<-EOS
      ./configure -prefix '#{prefix}'
               -system-sqlite -system-libpng -system-zlib
               -nomake demos -nomake examples -no-qt3support
               -release -cocoa -arch x86
               -confirm-license -opensource
               -I /usr/X11R6/include -L /usr/X11R6/lib
               -fast
               EOS

    system configure.gsub("\n", ' ').strip.squeeze(' ')
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