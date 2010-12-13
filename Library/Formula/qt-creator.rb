require 'formula'

class QtCreator <Formula
  homepage 'http://qt.gitorious.org/qt-creator'
  head 'git://gitorious.org/qt-creator/qt-creator.git'
  url 'http://get.qt.nokia.com/qtcreator/qt-creator-2.1.0-src.zip'
  md5 'a6e48b4347314fb2a92b77f40b4fc9a5'
  
  depends_on "qt"

  def install
    system "qmake -r"
    system "make"

    d = Dir.getwd
    prefix.install ['bin/Qt Creator.app']
    ln_s prefix + "Qt Creator.app", "/Applications"
  end

  def caveats; <<-EOS.undent
      Qt Creator.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps
    EOS
  end

end
