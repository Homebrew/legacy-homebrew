require 'formula'

class Comparepdf < Formula
  homepage 'http://www.qtrac.eu/comparepdf.html'
  url 'http://www.qtrac.eu/comparepdf-1.0.1.tar.gz'
  sha1 '01774dac78dca9b712d55bfdbaf58c4b0bd31295'

  depends_on 'qt'
  depends_on 'poppler' => 'with-qt4'

  def install
    # Generate makefile and disable .app creation
    if MacOS.version >= :mavericks && ENV.compiler == :clang
      spec = 'unsupported/macx-clang-libc++'
    else
      spec = 'macx-g++'
    end
    system 'qmake', '-spec', spec, 'CONFIG-=app_bundle'
    system 'make'

    bin.install 'comparepdf'
    man1.install 'comparepdf.1'
  end
end
