require 'formula'

class Qscintilla2 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  url 'http://downloads.sf.net/project/pyqt/QScintilla2/QScintilla-2.7.1/QScintilla-gpl-2.7.1.tar.gz'
  sha1 '646b5e6e6658c70d9bca034d670a3b56690662f2'

  depends_on 'pyqt'
  depends_on 'sip'

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'

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

    cd 'Python' do
      (share/'sip').mkpath
      system 'python', 'configure.py', "-o", lib, "-n", include,
                       "--apidir=#{prefix}/qsci",
                       "--destdir=#{lib}/#{which_python}/site-packages/PyQt4",
                       "--qsci-sipdir=#{share}/sip",
                       "--pyqt-sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system 'make'
      system 'make', 'install'
    end
  end

  def caveats; <<-EOS.undent
    For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
