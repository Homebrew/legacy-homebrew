require 'formula'

class Pdfcrack < Formula
  url 'http://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.11/pdfcrack-0.11.tar.gz'
  homepage 'http://pdfcrack.sourceforge.net/'
  sha1 'e8069837d879677ecc388326db8a005e83702fc1'

  def install
    system "make all"
    bin.install "pdfcrack"
  end
end
