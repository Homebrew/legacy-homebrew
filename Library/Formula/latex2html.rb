class Latex2html < Formula
  homepage "http://ctan.uib.no/help/Catalogue/entries/latex2html.html"
  url "http://ctan.uib.no/support/latex2html/latex2html-2012.tgz"
  sha256 "36b4b633507dba19a356d4ec5c6c145b242406b2b47cbe44aabf5e7efa2aa16f"

  depends_on "netpbm"
  depends_on "ghostscript"
  depends_on :tex => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end
end
