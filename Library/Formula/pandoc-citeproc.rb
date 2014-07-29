require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "http://hackage.haskell.org/package/pandoc-citeproc-0.3.1/pandoc-citeproc-0.3.1.tar.gz"
  sha1 "b972020fd6fa8447854b14d786c289062989b722"
  revision 1

  bottle do
    sha1 "234bfacbe8f484a7304277ffc4f4817fd5316267" => :mavericks
    sha1 "674107549aa368455939ae1219f2d40a53a92da2" => :mountain_lion
    sha1 "b2a27763e7392ab70599992db8f0ddf3caf23ce0" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "pandoc" => :recommended

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy"
      cabal_install "--only-dependencies", "--constraint=temporary==1.2.0.1"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    bib = testpath/"test.bib"
    bib.write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    assert `pandoc-citeproc --bib2yaml #{bib}`.include? "- publisher-place: Cambridge"
  end
end
