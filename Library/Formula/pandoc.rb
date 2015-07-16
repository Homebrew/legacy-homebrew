require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.0.6/pandoc-1.15.0.6.tar.gz"
  sha256 "d950968142526d5a765af7dfb26b47c3f60d4f883aa9d9eab668614179f1ed46"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "5114d7bd4a120905cc1f0448f7481644f9d11777bc81479df41e640a07c00616" => :yosemite
    sha256 "8af66294f92021e34229180d0e3323e027b2181c27de70c1504bafb5b6659698" => :mavericks
    sha256 "d5f32b584d366a51f7c21a854b40d69bab178c16192fb281acbc3e741650417c" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    input_markdown = <<-EOS.undent
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<-EOS.undent
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
