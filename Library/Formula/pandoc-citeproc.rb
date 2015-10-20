require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.8.0.1/pandoc-citeproc-0.8.0.1.tar.gz"
  sha256 "f9e1edb8ac529d4177feb0c374cf2b31f03dfcb53eabc342adb43d5aeaa37269"

  bottle do
    sha256 "5505151adf85ca2d15bcf55b26d8d0ce5f1c77006584f897ba55ce7ac023d099" => :el_capitan
    sha256 "6e495d845dbee3e7b3de3adb69f82ad5ec8b005e2d38d1bc477355fff7c85392" => :yosemite
    sha256 "739b5df3ca612de32bac6c698e01ac56c6e0f7509c04de0bab0efcc284a35ef3" => :mavericks
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
