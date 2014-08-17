require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.4/pandoc-citeproc-0.4.tar.gz"
  sha1 "49257c3aa01144e8b9142c079e9cc1d92f97d7d8"

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
      cabal_install "--only-dependencies"
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
