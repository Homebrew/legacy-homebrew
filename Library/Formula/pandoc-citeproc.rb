require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.7.2/pandoc-citeproc-0.7.2.tar.gz"
  sha256 "3eddf364561a8f175493cdd32eb4c7994164d2c27625c07cf13bfd491539f936"

  bottle do
    sha256 "f11bd1023f207b5c2655e51a7494dbf8e5c065ebaebce2bca6a79fd9c5650360" => :yosemite
    sha256 "5262e34bd21b6d3e6eb7bb4883949e17d4268fdb99892d5420a98b237b55c172" => :mavericks
    sha256 "b5ebf2ba3ff01756661c748bccdaf8719d7dd7eb03d325bbf17522ff74ee5121" => :mountain_lion
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
