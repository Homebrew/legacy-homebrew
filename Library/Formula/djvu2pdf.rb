require 'formula'

class Djvu2pdf < Formula
  url 'http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.1.tar.gz'
  homepage 'http://0x2a.at/s/projects/djvu2pdf'
  md5 '47a77ec1693c352dda1cd7ced3f50c1c'

  depends_on 'ghostscript'
  depends_on 'djvulibre'

  def install
    system "chmod +x djvu2pdf && mv djvu2pdf /usr/local/bin"
    #system "mv djvu2pdf.1.gz #{prefix}/share/man"
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "/usr/bin/false"
  end
end
