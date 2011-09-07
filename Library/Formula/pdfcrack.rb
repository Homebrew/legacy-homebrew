require 'formula'

class Pdfcrack < Formula
  url 'http://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.11/pdfcrack-0.11.tar.gz'
  homepage 'http://pdfcrack.sourceforge.net/'
  md5 '00bdb4c44dd209f493fc02d38c1a6377'

  def install
    system "make all"
    bin.install "pdfcrack"
  end
end
