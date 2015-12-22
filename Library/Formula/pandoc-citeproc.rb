require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://github.com/jgm/pandoc-citeproc/archive/0.8.1.3.tar.gz"
  sha256 "d1806c65b35851abb44faa90c0ba60e15a11656420713a5907dfa1563c32be5b"

  bottle do
    sha256 "007625243bcac2f5306caf8d80b620b6e75dc88d5f4a8130d5ab3713dcd3bce8" => :el_capitan
    sha256 "ec979c4f3b6ca8c62c0970e989633e27b4988566b42fbbbc1497a00098dc8c52" => :yosemite
    sha256 "5a8966152d8c631d1dcf5b9d2363b1cb3b372d64e823eeac5858357fcec9f858" => :mavericks
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
