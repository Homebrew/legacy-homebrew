class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2015.tar.gz"
  sha256 "248cf84c70dd31221ddc69ef7ce0e720aadd26b572ee412827eae62f0eefb8dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8ec8e21b79f4de23cc8d6731671cf5f45e4ea6d9df29039cd372732fda93c87" => :el_capitan
    sha256 "c34c5a1c756cde2bb4e81f322a1317ec776a613d25d78ee9cdb2611a99396cbd" => :yosemite
    sha256 "792094083d7168f6e80d1528cc930bd657d57407b47b289cd38e256d9c739a3c" => :mavericks
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
