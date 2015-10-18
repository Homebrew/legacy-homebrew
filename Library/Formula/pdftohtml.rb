class Pdftohtml < Formula
  desc "PDF to HTML converter (based on xpdf)"
  homepage "http://pdftohtml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"

  conflicts_with "poppler", :because => "both install `pdftohtml` binaries"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end
