require 'formula'

class Latex2html < Formula
    homepage 'http://ctan.uib.no/help/Catalogue/entries/latex2html.html'
    url 'http://ctan.uib.no/support/latex2html/latex2html-2008.tar.gz'
    version '1.71'
    sha1 '5e0aa47572e0c13a4c5da51e963d5496be3f86e7'

    depends_on 'netpbm'
    depends_on 'ghostscript' => :optional

    def install
        system "./configure", "--prefix=#{prefix}", "--without-mktexlsr"
        system "make install"
    end
end
