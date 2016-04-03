require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz"
  sha256 "7b14e1bcb78a7e2ad1e585f127be7efd20225c9f9b5131d507b376b62cd77e32"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "a41e10d0080667ba6777473be848ffcf16d39ec258832a3d95b6d4b9cd1e4386" => :el_capitan
    sha256 "d70667981bff53646d462614c4132bfbb12ef6dcfd4b44d55b39122d19e2e28a" => :yosemite
    sha256 "0a353ef662cfc105533a9834b90e701fa8d22fe1853c1a2f51cdae2b03afb9e2" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
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
