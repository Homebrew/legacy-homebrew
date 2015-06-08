require "formula"

class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "http://pdfcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.14/pdfcrack-0.14.tar.gz"
  sha1 "15d74431a06430b910c8e9ad2b1f5b8635c94181"

  def install
    system "make all"
    bin.install "pdfcrack"
  end
end
