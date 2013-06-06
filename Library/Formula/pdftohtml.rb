require 'formula'

class Pdftohtml < Formula
  homepage 'http://pdftohtml.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz'
  sha1 '409572da65cf5234d026a5b199a81a26e75ca4d8'

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end
