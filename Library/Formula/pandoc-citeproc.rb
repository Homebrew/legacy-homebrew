require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.7.3/pandoc-citeproc-0.7.3.tar.gz"
  sha256 "72fc81d962812d037bb78c6d38d602ca2c6895f0436c8be94cb71600ed288e68"

  bottle do
    sha256 "216ad46562f7ee3ae5a0e19b855b3f8c27c8d2907beedf9dd41d5634179ab9a4" => :yosemite
    sha256 "0f5cc2caa5ba5c9f687d057a3dfe462e6e01623dc42d556148e8e6e23332622d" => :mavericks
    sha256 "40e380d4a8c5e63a81f00358d8cffa743381e4b825a8e925a63b66d0da232154" => :mountain_lion
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
