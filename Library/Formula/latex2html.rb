require 'formula'

class Latex2html < Formula
    url 'http://ctan.uib.no/support/latex2html/latex2html-2008.tar.gz'
    homepage 'http://ctan.uib.no/help/Catalogue/entries/latex2html.html'
    md5 '275ab6cfa8ca9328446b7f40d8dc302e'
    version '1.71'

    depends_on 'netpbm'
    depends_on 'ghostscript' => :optional

    def install
        system "./configure", "--prefix=#{prefix}", "--without-mktexlsr"
        system "make install"
    end
end
