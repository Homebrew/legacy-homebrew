require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz"
  sha256 "7b14e1bcb78a7e2ad1e585f127be7efd20225c9f9b5131d507b376b62cd77e32"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "b0af79f5ce1fba4259011cd8445322fdba4b3f7e6cd6a522708c2f1085c044cc" => :el_capitan
    sha256 "c9341f2a7825934fca7919cb4dbb2cefb35a4eb9ca8d9a237ef8e78081c8ec6a" => :yosemite
    sha256 "e5752c816353dd0cfd8eaf9f2f6cd3c80443af4a97089492bb373ed2b69d4134" => :mavericks
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
