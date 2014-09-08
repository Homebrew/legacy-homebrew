require 'formula'

class Latex2html < Formula
  homepage 'http://ctan.uib.no/help/Catalogue/entries/latex2html.html'
  url 'http://ctan.uib.no/support/latex2html/latex2html-2012.tgz'
  sha1 '54b42d3fb812b0bf3d25bbde7e0ea2daf84e69ff'

  depends_on 'netpbm'
  depends_on 'ghostscript' => :optional
  depends_on :tex => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make install"
  end
end
