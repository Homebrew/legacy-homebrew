require 'formula'

class Diffpdf < Formula
  homepage 'http://www.qtrac.eu/diffpdf-foss.html'
  url 'http://www.qtrac.eu/diffpdf-2.1.3.tar.gz'
  sha1 '663ecb7666a4b7d6fbd1a37327fd1f895fae69b8'

  depends_on 'qt'
  depends_on 'poppler' => 'with-qt4'

  def install
    # The 2.0 sources shipped without translation files. Generate them so that
    # compilation does not fail.
    system 'lrelease', 'diffpdf.pro'
    # Generate makefile and disable .app creation
    if MacOS.version >= :mavericks && ENV.compiler == :clang
      spec = 'unsupported/macx-clang-libc++'
    else
      spec = 'macx-g++'
    end

    system 'qmake', '-spec', spec, 'CONFIG-=app_bundle'
    system 'make'

    bin.install 'diffpdf'
    man1.install 'diffpdf.1'
  end
end
