require 'formula'

class Pngcheck < Formula
  homepage 'http://www.libpng.org/pub/png/apps/pngcheck.html'
  url 'https://downloads.sourceforge.net/project/png-mng/pngcheck/2.3.0/pngcheck-2.3.0.tar.gz'
  sha1 'e7f1535abbf2f809e036a9a43c759eeac5e39350'
  revision 1

  def install
    system 'make -f Makefile.unx ZINC= ZLIB=-lz'
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end
end
