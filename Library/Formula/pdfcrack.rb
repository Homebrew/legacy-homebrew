require 'formula'

class Pdfcrack < Formula
  homepage 'http://pdfcrack.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.13/pdfcrack-0.13.tar.gz'
  sha1 'fd5d99bd5a1edb3885219f84da718e329f899843'

  def install
    system "make all"
    bin.install "pdfcrack"
  end
end
