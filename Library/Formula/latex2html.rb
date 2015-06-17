class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://ctan.uib.no/help/Catalogue/entries/latex2html.html"
  url "http://ctan.uib.no/support/latex2html/latex2html-2012.tgz"
  sha256 "36b4b633507dba19a356d4ec5c6c145b242406b2b47cbe44aabf5e7efa2aa16f"

  bottle do
    sha256 "a34ed6cad64be682a18ef461cf96e91bb41cdd5766256a5255b279870efc7c51" => :yosemite
    sha256 "ec27b4810f54db343c84e5bc04a0a21369583f2d4d21286107cd409a70867662" => :mavericks
    sha256 "1c3bddc6c88890740d7036cdcdbc8554b289312e00b15e0f98b1386af40dcff1" => :mountain_lion
  end

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
