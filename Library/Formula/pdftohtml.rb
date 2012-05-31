require 'formula'

class Pdftohtml < Formula
  url 'http://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz'
  homepage 'http://pdftohtml.sourceforge.net/'
  md5 '2d82996faaf2b9439f8395743c1c163d'

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end
