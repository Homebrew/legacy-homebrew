class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "http://pdfcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.14/pdfcrack-0.14.tar.gz"
  sha256 "ac88eca576cebb40c4a63cd90542664de7d8f1b39885db5a7ac021d8b0c6a95c"

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end
end
