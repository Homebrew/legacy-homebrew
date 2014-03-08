require 'formula'

class Pdftoipe < Formula
  homepage 'http://ipe7.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipe7/tools/pdftoipe-20130124-src.tar.gz'
  sha1 '081141129f9a2c55e6732e597fd8e94cc96f69e3'

  depends_on 'pkg-config' => :build
  depends_on 'poppler'

  def install
    system "make"
    bin.install "pdftoipe"
    man1.install "pdftoipe.1"
    doc.install "readme.txt"
  end
end
