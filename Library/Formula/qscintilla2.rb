require 'formula'

class Qscintilla2 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  url 'http://downloads.sf.net/project/pyqt/QScintilla2/QScintilla-2.7.1/QScintilla-gpl-2.7.1.tar.gz'
  sha1 '646b5e6e6658c70d9bca034d670a3b56690662f2'

  depends_on 'pyqt'
  depends_on 'sip'
  depends_on :python

  def install

    cd 'Qt4Qt5' do
      inreplace 'qscintilla.pro' do |s|
        s.gsub! '$$[QT_INSTALL_LIBS]', lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", "#{prefix}/trans"
        s.gsub! "$$[QT_INSTALL_DATA]", "#{prefix}/data"
      end

      system "qmake", "qscintilla.pro"
      system "make"
      system "make", "install"
    end

    python do
      cd 'Python' do
        (share/"sip#{python.if3then3}").mkpath
        system python, 'configure.py', "-o", lib, "-n", include,
                         "--apidir=#{prefix}/qsci",
                         "--destdir=#{python.site_packages}/PyQt4",
                         "--qsci-sipdir=#{share}/sip#{python.if3then3}",
                         "--pyqt-sipdir=#{HOMEBREW_PREFIX}/share/sip#{python.if3then3}"
        system 'make'
        system 'make', 'install'
      end
    end
  end

  def caveats
    python.standard_caveats if python
  end

end
