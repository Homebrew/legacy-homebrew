class Djvu2pdf < Formula
  desc "Small tool to convert Djvu files to PDF files"
  homepage "http://0x2a.at/s/projects/djvu2pdf"
  url "http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-0.9.2.tar.gz"
  sha256 "afe86237bf4412934d828dfb5d20fe9b584d584ef65b012a893ec853c1e84a6c"

  depends_on "djvulibre"
  depends_on "ghostscript"

  def install
    bin.install "djvu2pdf"
    man1.install "djvu2pdf.1.gz"
  end

  test do
    system "#{bin}/djvu2pdf", "-h"
  end
end
