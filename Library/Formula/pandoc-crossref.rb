class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.0.1/pandoc-crossref-0.2.0.1.tar.gz"
  sha256 "44bdbc38d8d7a743951a2333fb70b33a6497b2d50ccdb5696736fdc5133aef21"

  bottle do
    sha256 "2edd7fe6757e7a3b4599b459940ae77dcb4bfa265d6ef2555b8139d56a2b6750" => :el_capitan
    sha256 "66d0ccc3d84db7029b841db98c575d457881935377922668e1e1cf631c3a3242" => :yosemite
    sha256 "35ce5fe43ada3cdadfd1552c0cffbe0032c499f868c951de40789877755f4dcb" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    md = testpath/"test.md"
    md.write <<-EOS.undent
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}


    EOS
    system "pandoc", "-F", "pandoc-crossref", md
  end
end
