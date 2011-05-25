require 'formula'

class Qscintilla2 < Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/QScintilla-gpl-2.5.1.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  md5 'dd7edef5ff674d307057a3c12dbd8fce'

  depends_on 'pyqt'

  def install

    Dir.chdir 'Qt4'

    inreplace 'qscintilla.pro' do |s|
      s.gsub! '$$[QT_INSTALL_LIBS]', lib 
      s.gsub! "$$[QT_INSTALL_HEADERS]", include
      s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", "#{prefix}/trans"
      s.gsub! "$$[QT_INSTALL_DATA]", "#{prefix}/data"
    end

    system "qmake", "qscintilla.pro"
    system "make"
    system "make", "install"

    Dir.chdir '../Python'

    system 'python', 'configure.py', "-o", lib, "-n", include, "--apidir=#{prefix}/qsci", "--destdir=#{lib}/python/PyQt4", "--sipdir=#{share}/sip"
    system 'make'
    system 'make', 'install'
  end
end
