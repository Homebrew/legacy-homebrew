require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://github.com/jgm/pandoc-citeproc/archive/0.8.1.3.tar.gz"
  sha256 "d1806c65b35851abb44faa90c0ba60e15a11656420713a5907dfa1563c32be5b"

  bottle do
    sha256 "4746358b6bd2d4aab12183bac43a5601b101e8f13a39a7ea9181dc6a25aa2bfc" => :el_capitan
    sha256 "7317b36cba86ffe0679cdefc39ae794e8dcb3b7af9a26ac0e66eddbfec32d0ff" => :yosemite
    sha256 "77a7cef82d67ea5d47a21ad02e3df8e60338d4b548fab6de4aaf18bfa00e7e06" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  setup_ghc_compilers

  def install
    install_cabal_package
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
