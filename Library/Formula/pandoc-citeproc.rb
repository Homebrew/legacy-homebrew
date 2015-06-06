require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.7.1.1/pandoc-citeproc-0.7.1.1.tar.gz"
  sha256 "415d97bafa36b7807a78747c2dd9a5e80042d0ad6de99e2ec3c13213e87926d9"

  bottle do
    sha256 "304c122d67adbcff13fd7fb43852234c9138983d931c45b53bf6ab0160b16a98" => :yosemite
    sha256 "72e0a53626551fd9f889879b86903c8b2775e3f688f57889bb09a1d7f62abdc6" => :mavericks
    sha256 "441ca80c3bf92cc1b6416e796fc64b57eabe122619c96a944dd6029dade3541c" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  setup_ghc_compilers

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
    system "pandoc-citeproc", "--bib2yaml", bib
  end
end
