require 'formula'

class Qscintilla2 < Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/QScintilla-gpl-2.6.tar.gz'
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  md5 '0605a8006ea752ec2d1d7fc4791d1c75'

  depends_on 'pyqt'
  depends_on 'sip'

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/python", ':'

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

  def caveats; <<-EOS.undent
    This formula includes a Python module that will not be functional until you
    amend your PYTHONPATH:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
    EOS
  end
end
