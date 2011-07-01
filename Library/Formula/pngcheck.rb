require 'formula'

class Pngcheck < Formula
  url 'http://downloads.sourceforge.net/project/png-mng/pngcheck/2.3.0/pngcheck-2.3.0.tar.gz'
  homepage 'http://www.libpng.org/pub/png/apps/pngcheck.html'
  md5 '980bd6d9a3830fdce746d7fe3c9166ee'

  def install
    system 'make pngcheck'
    bin.install 'pngcheck'
  end
end
