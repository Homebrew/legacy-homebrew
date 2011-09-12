require 'formula'

class Djvu2pdf < Formula
  url 'http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.2.tar.gz'
  homepage 'http://0x2a.at/s/projects/djvu2pdf'
  md5 'af93c29a857a014f86dffcff6c773ef1'

  depends_on 'ghostscript'
  depends_on 'djvulibre'

  def install
    system "chmod +x djvu2pdf"
    bin.install 'djvu2pdf'
    man1.install 'djvu2pdf.2.gz'
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "#{bin}/djvu2pdf -h"
  end
end
