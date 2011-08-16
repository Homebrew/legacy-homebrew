require 'formula'

def poppler_has_qt4?
  poppler = Formula.factory('poppler')
  not Dir[poppler.include + '**/*qt4.h'].empty?
end

class Diffpdf < Formula
  homepage 'http://www.qtrac.eu/diffpdf.html'
  url 'http://www.qtrac.eu/diffpdf-1.2.2.tar.gz'
  md5 '1c35151d9216e2225aa921e1faef91ca'

  depends_on 'qt'
  depends_on 'poppler'

  def install
    if poppler_has_qt4?
      # Generate makefile and disable .app creation
      system 'qmake -spec macx-g++ CONFIG-=app_bundle'
      system 'make'

      bin.install 'diffpdf'
      man1.install 'diffpdf.1'
    else
      onoe <<-EOS.undent
        Could not locate header files for poppler-qt4. This probably means that Poppler
        was not installed with support for Qt. Try reinstalling Poppler using the
        `--with-qt4` option.
      EOS

      exit 1
    end
  end
end
