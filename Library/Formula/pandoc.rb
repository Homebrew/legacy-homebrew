require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17.0.2/pandoc-1.17.0.2.tar.gz"
  sha256 "f099eecf102cf215741da7a993d90f0ab135d6f84cb23f9da77050bd1c9a9d53"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "70efdcd9cd8ceba07810729eaffd24ed7865827517d0f2d78aa84632ecc9c6a3" => :el_capitan
    sha256 "dead3ce712405001c9437e6cdd3db44fb507499a10e068198e686f9c58c4bff4" => :yosemite
    sha256 "28e8ec96f5037cb6410106bcea83986e2ba7ef22bc0bfc9b152b6732b085fbe2" => :mavericks
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
