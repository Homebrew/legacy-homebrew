require 'formula'

class Djvu2pdf < Formula
  homepage 'http://0x2a.at/s/projects/djvu2pdf'
  url 'http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.2.tar.gz'
  sha1 'eb34c8a6381673e531fbbd21619606e20fdb1d97'

  depends_on 'djvulibre'
  depends_on 'ghostscript'

  def install
    bin.install 'djvu2pdf'
    man1.install 'djvu2pdf.1.gz'
  end

  test do
    system "#{bin}/djvu2pdf", "-h"
  end
end
